const express = require('express');
const multer = require('multer');
const AWS = require('aws-sdk');
const dotenv = require('dotenv');
const fs = require('fs');
const path = require('path');

dotenv.config();

const app = express();
const upload = multer({ dest: 'uploads/' });

// Configure MinIO (S3-compatible storage)
const s3 = new AWS.S3({
    endpoint: process.env.MINIO_ENDPOINT,
    accessKeyId: process.env.MINIO_ACCESS_KEY,
    secretAccessKey: process.env.MINIO_SECRET_KEY,
    s3ForcePathStyle: true, // Needed for MinIO
});

const BUCKET_NAME = process.env.MINIO_BUCKET_NAME;

// Upload API
app.post('/upload', upload.single('file'), (req, res) => {
    if (!req.file) {
        return res.status(400).send('No file uploaded.');
    }

    try {
        const fileContent = fs.readFileSync(req.file.path); // Read the uploaded file
        const fileKey = `${Date.now()}-${req.file.originalname}`;

        const params = {
            Bucket: BUCKET_NAME,
            Key: fileKey,
            Body: fileContent,
            ContentType: req.file.mimetype,
        };

        s3.upload(params, (err, data) => {
            if (err) {
                console.error('S3 upload failed:', err);
                return res.status(500).send('Failed to upload file.');
            }
            res.status(200).json({
                message: 'File uploaded successfully!',
                url: data.Location,
            });
        });
    } catch (error) {
        console.error('File processing failed:', error);
        res.status(500).send('Failed to process and upload file.');
    }
});

app.listen(3000, () => {
    console.log('File uploader is running on port 3000.');
});
