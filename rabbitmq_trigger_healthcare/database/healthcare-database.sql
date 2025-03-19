DROP TABLE IF EXISTS lab_results;
DROP TABLE IF EXISTS lab_tests;
DROP TABLE IF EXISTS labs;
DROP TABLE IF EXISTS patients;

CREATE TABLE patients (
    patient_id UUID PRIMARY KEY,  -- Universally unique identifier
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE labs (
    lab_id UUID PRIMARY KEY,
    lab_name VARCHAR(255) NOT NULL,  -- E.g., "CityLab Diagnostics"
    address TEXT,
    certification_number VARCHAR(50)  -- Lab accreditation ID
);

CREATE TABLE lab_tests (
    test_id UUID PRIMARY KEY,
    test_code VARCHAR(20) UNIQUE NOT NULL,  -- E.g., "GLUCOSE" or "CBC"
    test_name VARCHAR(255) NOT NULL,        -- E.g., "Blood Glucose Level"
    description TEXT,
    unit VARCHAR(20),                       -- E.g., "mg/dL", "mmol/L"
    reference_range_low NUMERIC,            -- Normal lower bound
    reference_range_high NUMERIC            -- Normal upper bound
);

CREATE TABLE lab_results (
    result_id UUID PRIMARY KEY,
    patient_id UUID REFERENCES patients(patient_id) ON DELETE CASCADE,
    test_id UUID REFERENCES lab_tests(test_id),
    lab_id UUID REFERENCES labs(lab_id),
    result_value JSONB NOT NULL,  -- Flexible storage (numeric, text, or complex results)
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'abnormal')),
    ordered_by VARCHAR(255),      -- Physician who ordered the test
    collected_at TIMESTAMPTZ,     -- When the sample was taken
    resulted_at TIMESTAMPTZ,      -- When the result was finalized
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for fast lookups
CREATE INDEX idx_lab_results_patient ON lab_results(patient_id);
CREATE INDEX idx_lab_results_test ON lab_results(test_id);
