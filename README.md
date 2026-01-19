# SQLSIM: Analytical Queries by Similarity in Relational DBMS

**SQLSIM** is a strategy for executing analytical similarity queries and clustering directly within a Relational DBMS (PostgreSQL) using User-Defined Functions (UDFs). By moving the processing logic to the data, this approach reduces impedance mismatch and improves performance for specific analytical workloads.

## 🎓 Academic Context

This repository contains the source code and experiments developed for my Master's Thesis in Computer Science at the **Federal University of Uberlândia (UFU)**.

* **Thesis Title:** SQLSIM: Analytical queries by similarity in relational DBMS
* **Full Text:** [Access via UFU Repository](https://repositorio.ufu.br/handle/123456789/45599)

### Author & Advisors
* **Author:** Lívio Mendonça [![ORCID](https://img.shields.io/badge/ORCID-0009--0003--0327--8083-green.svg)](https://orcid.org/0009-0003-0327-8083)
* **Advisor:** Prof. Dr. Humberto Luiz Razente
* **Co-Advisor:** Prof. Dra. Maria Camila Nardini Barioni

---

## 📂 Repository Structure

* `/main.sql`: Core implementation of the similarity and clustering algorithms in PL/pgSQL.
* `/dataviz`: Jupyter Notebooks used for data visualization and analyzing experiment results. **(Contributed by [Antonio Fernandes](https://github.com/liviomendonca/sqlsim/commit/348db18b83d76772c0ff803e7e0cf784750e447d))**
* `/examples`: Case studies, including the Breast Cancer dataset experiments.
* `compose.yml`: Docker composition for setting up the PostgreSQL environment with necessary extensions.

## 🚀 Getting Started

### Prerequisites
* Docker & Docker Compose
* PostgreSQL Client (psql) or DBeaver

### Installation
1.  Clone the repository:
    ```bash
    git clone https://github.com/liviomendonca/sqlsim.git
    cd sqlsim
    ```

2.  Start the database container:
    ```bash
    docker compose up -d
    ```

3.  Load the functions:
    ```bash
    psql -h localhost -U postgres -d sqlsim -f main.sql
    ```

## 🛠 Technologies
* **Database:** PostgreSQL
* **Language:** PL/pgSQL (Server-side programming)
* **Analysis:** Python (Jupyter, Pandas, Matplotlib) for validation and visualization

---

## 🤝 Acknowledgements

Special thanks to **[Antonio Fernandes](https://github.com/fvantonio1)** for his significant contributions to the data visualization modules (`/dataviz`) used in this project.
