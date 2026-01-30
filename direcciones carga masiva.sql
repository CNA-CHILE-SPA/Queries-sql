SELECT
  T0."CardCode",
  T1."AddrType",
  T1."Address",
  T1."Address2",
  T1."Address3",
  T1."Street",
  T1."Block",
  T1."City",
  T1."ZipCode",
  T1."County",
  T1."State",
  T1."Country",
  T1."StreetNo",
  T1."Building",
  T1."GlblLocNum",
  T1."TaxOffice",
  T1."TaxCode"
FROM
  OCRD T0
  INNER JOIN CRD1 T1 ON T0."CardCode" = T1."CardCode"
WHERE
  T0."CardCode" LIKE 'CN%'