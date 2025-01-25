CREATE TABLE job_applied (
    job_id INT,
    application_sent_date Date,
    custom_resume Boolean,
    resume_file_name varchar(255),
    cover_letter_sent Boolean,
    cover_letter_file_name varchar(255),
    status varchar(50)
);
INSERT into job_applied
            (job_id,
            application_sent_date,
            custom_resume,
            resume_file_name,
            cover_letter_sent,
            cover_letter_file_name,
            status)
values      (1,
            '2025-01-21',
            true,
            'resume_01.pdf',
            true,
            'cover_letter_01.pdf',
            'submitted'),
            (2,
            '2025-02-21',
            true,
            'resume_02.pdf',
            true,
            'cover_letter_02.pdf',
            'submitted'),
            (3,
            '2025-01-21',
            true,
            'resume_03.pdf',
            true,
            'cover_letter_03.pdf',
            'submitted'),
            (4,
            '2025-04-21',
            true,
            'resume_04.pdf',
            true,
            'cover_letter_04.pdf',
            'rejected');

ALTER TABLE job_applied
add contact varchar(50);

UPDATE job_applied
set    contact = 'bcgdh cbdhs'
where  job_id = 1;

UPDATE job_applied
set    contact = 'nsjd cbdhs'
where  job_id = 2;

UPDATE job_applied
set    contact = 'bcgdh udsju'
where  job_id = 3;

UPDATE job_applied
set    contact = 'dwqu kdoi'
where  job_id = 4;

ALTER TABLE job_applied
rename column contact to contact_name;

ALTER TABLE job_applied
ALTER column contact_name type text;

ALTER TABLE job_applied
drop column contact_name;

SELECT * FROM job_applied;

DROP TABLE job_applied;

TRUNCATE TABLE job_applied;