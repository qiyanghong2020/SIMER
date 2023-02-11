// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// write_bfile
void write_bfile(SEXP pBigMat, std::string bed_file, int threads, bool verbose);
RcppExport SEXP _simer_write_bfile(SEXP pBigMatSEXP, SEXP bed_fileSEXP, SEXP threadsSEXP, SEXP verboseSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< SEXP >::type pBigMat(pBigMatSEXP);
    Rcpp::traits::input_parameter< std::string >::type bed_file(bed_fileSEXP);
    Rcpp::traits::input_parameter< int >::type threads(threadsSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    write_bfile(pBigMat, bed_file, threads, verbose);
    return R_NilValue;
END_RCPP
}
// read_bfile
void read_bfile(std::string bed_file, SEXP pBigMat, long maxLine, int threads, bool verbose);
RcppExport SEXP _simer_read_bfile(SEXP bed_fileSEXP, SEXP pBigMatSEXP, SEXP maxLineSEXP, SEXP threadsSEXP, SEXP verboseSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type bed_file(bed_fileSEXP);
    Rcpp::traits::input_parameter< SEXP >::type pBigMat(pBigMatSEXP);
    Rcpp::traits::input_parameter< long >::type maxLine(maxLineSEXP);
    Rcpp::traits::input_parameter< int >::type threads(threadsSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    read_bfile(bed_file, pBigMat, maxLine, threads, verbose);
    return R_NilValue;
END_RCPP
}
// GenoFilter
List GenoFilter(const SEXP pBigMat, Nullable<IntegerVector> keepInds, Nullable<double> filterGeno, Nullable<double> filterHWE, Nullable<double> filterMind, Nullable<double> filterMAF, int threads, bool verbose);
RcppExport SEXP _simer_GenoFilter(SEXP pBigMatSEXP, SEXP keepIndsSEXP, SEXP filterGenoSEXP, SEXP filterHWESEXP, SEXP filterMindSEXP, SEXP filterMAFSEXP, SEXP threadsSEXP, SEXP verboseSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const SEXP >::type pBigMat(pBigMatSEXP);
    Rcpp::traits::input_parameter< Nullable<IntegerVector> >::type keepInds(keepIndsSEXP);
    Rcpp::traits::input_parameter< Nullable<double> >::type filterGeno(filterGenoSEXP);
    Rcpp::traits::input_parameter< Nullable<double> >::type filterHWE(filterHWESEXP);
    Rcpp::traits::input_parameter< Nullable<double> >::type filterMind(filterMindSEXP);
    Rcpp::traits::input_parameter< Nullable<double> >::type filterMAF(filterMAFSEXP);
    Rcpp::traits::input_parameter< int >::type threads(threadsSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    rcpp_result_gen = Rcpp::wrap(GenoFilter(pBigMat, keepInds, filterGeno, filterHWE, filterMind, filterMAF, threads, verbose));
    return rcpp_result_gen;
END_RCPP
}
// Mat2BigMat
void Mat2BigMat(const SEXP pBigMat, IntegerMatrix mat, Nullable<IntegerVector> colIdx, int op, int threads);
RcppExport SEXP _simer_Mat2BigMat(SEXP pBigMatSEXP, SEXP matSEXP, SEXP colIdxSEXP, SEXP opSEXP, SEXP threadsSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const SEXP >::type pBigMat(pBigMatSEXP);
    Rcpp::traits::input_parameter< IntegerMatrix >::type mat(matSEXP);
    Rcpp::traits::input_parameter< Nullable<IntegerVector> >::type colIdx(colIdxSEXP);
    Rcpp::traits::input_parameter< int >::type op(opSEXP);
    Rcpp::traits::input_parameter< int >::type threads(threadsSEXP);
    Mat2BigMat(pBigMat, mat, colIdx, op, threads);
    return R_NilValue;
END_RCPP
}
// BigMat2BigMat
void BigMat2BigMat(const SEXP pBigMat, const SEXP pBigmat, Nullable<NumericVector> colIdx, int op, int threads);
RcppExport SEXP _simer_BigMat2BigMat(SEXP pBigMatSEXP, SEXP pBigmatSEXP, SEXP colIdxSEXP, SEXP opSEXP, SEXP threadsSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const SEXP >::type pBigMat(pBigMatSEXP);
    Rcpp::traits::input_parameter< const SEXP >::type pBigmat(pBigmatSEXP);
    Rcpp::traits::input_parameter< Nullable<NumericVector> >::type colIdx(colIdxSEXP);
    Rcpp::traits::input_parameter< int >::type op(opSEXP);
    Rcpp::traits::input_parameter< int >::type threads(threadsSEXP);
    BigMat2BigMat(pBigMat, pBigmat, colIdx, op, threads);
    return R_NilValue;
END_RCPP
}
// GenoMixer
void GenoMixer(const SEXP pBigMat, const SEXP pBigmat, IntegerVector sirIdx, IntegerVector damIdx, int nBlock, int op, int threads);
RcppExport SEXP _simer_GenoMixer(SEXP pBigMatSEXP, SEXP pBigmatSEXP, SEXP sirIdxSEXP, SEXP damIdxSEXP, SEXP nBlockSEXP, SEXP opSEXP, SEXP threadsSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const SEXP >::type pBigMat(pBigMatSEXP);
    Rcpp::traits::input_parameter< const SEXP >::type pBigmat(pBigmatSEXP);
    Rcpp::traits::input_parameter< IntegerVector >::type sirIdx(sirIdxSEXP);
    Rcpp::traits::input_parameter< IntegerVector >::type damIdx(damIdxSEXP);
    Rcpp::traits::input_parameter< int >::type nBlock(nBlockSEXP);
    Rcpp::traits::input_parameter< int >::type op(opSEXP);
    Rcpp::traits::input_parameter< int >::type threads(threadsSEXP);
    GenoMixer(pBigMat, pBigmat, sirIdx, damIdx, nBlock, op, threads);
    return R_NilValue;
END_RCPP
}
// hasNA
bool hasNA(SEXP pBigMat, const int threads);
RcppExport SEXP _simer_hasNA(SEXP pBigMatSEXP, SEXP threadsSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< SEXP >::type pBigMat(pBigMatSEXP);
    Rcpp::traits::input_parameter< const int >::type threads(threadsSEXP);
    rcpp_result_gen = Rcpp::wrap(hasNA(pBigMat, threads));
    return rcpp_result_gen;
END_RCPP
}
// hasNABed
bool hasNABed(std::string bed_file, int ind, long maxLine, int threads, bool verbose);
RcppExport SEXP _simer_hasNABed(SEXP bed_fileSEXP, SEXP indSEXP, SEXP maxLineSEXP, SEXP threadsSEXP, SEXP verboseSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< std::string >::type bed_file(bed_fileSEXP);
    Rcpp::traits::input_parameter< int >::type ind(indSEXP);
    Rcpp::traits::input_parameter< long >::type maxLine(maxLineSEXP);
    Rcpp::traits::input_parameter< int >::type threads(threadsSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    rcpp_result_gen = Rcpp::wrap(hasNABed(bed_file, ind, maxLine, threads, verbose));
    return rcpp_result_gen;
END_RCPP
}
// PedigreeCorrector
DataFrame PedigreeCorrector(const SEXP pBigMat, StringVector rawGenoID, DataFrame rawPed, Nullable<StringVector> candSirID, Nullable<StringVector> candDamID, double exclThres, double assignThres, Nullable<NumericVector> birthDate, int threads, bool verbose);
RcppExport SEXP _simer_PedigreeCorrector(SEXP pBigMatSEXP, SEXP rawGenoIDSEXP, SEXP rawPedSEXP, SEXP candSirIDSEXP, SEXP candDamIDSEXP, SEXP exclThresSEXP, SEXP assignThresSEXP, SEXP birthDateSEXP, SEXP threadsSEXP, SEXP verboseSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const SEXP >::type pBigMat(pBigMatSEXP);
    Rcpp::traits::input_parameter< StringVector >::type rawGenoID(rawGenoIDSEXP);
    Rcpp::traits::input_parameter< DataFrame >::type rawPed(rawPedSEXP);
    Rcpp::traits::input_parameter< Nullable<StringVector> >::type candSirID(candSirIDSEXP);
    Rcpp::traits::input_parameter< Nullable<StringVector> >::type candDamID(candDamIDSEXP);
    Rcpp::traits::input_parameter< double >::type exclThres(exclThresSEXP);
    Rcpp::traits::input_parameter< double >::type assignThres(assignThresSEXP);
    Rcpp::traits::input_parameter< Nullable<NumericVector> >::type birthDate(birthDateSEXP);
    Rcpp::traits::input_parameter< int >::type threads(threadsSEXP);
    Rcpp::traits::input_parameter< bool >::type verbose(verboseSEXP);
    rcpp_result_gen = Rcpp::wrap(PedigreeCorrector(pBigMat, rawGenoID, rawPed, candSirID, candDamID, exclThres, assignThres, birthDate, threads, verbose));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_simer_write_bfile", (DL_FUNC) &_simer_write_bfile, 4},
    {"_simer_read_bfile", (DL_FUNC) &_simer_read_bfile, 5},
    {"_simer_GenoFilter", (DL_FUNC) &_simer_GenoFilter, 8},
    {"_simer_Mat2BigMat", (DL_FUNC) &_simer_Mat2BigMat, 5},
    {"_simer_BigMat2BigMat", (DL_FUNC) &_simer_BigMat2BigMat, 5},
    {"_simer_GenoMixer", (DL_FUNC) &_simer_GenoMixer, 7},
    {"_simer_hasNA", (DL_FUNC) &_simer_hasNA, 2},
    {"_simer_hasNABed", (DL_FUNC) &_simer_hasNABed, 5},
    {"_simer_PedigreeCorrector", (DL_FUNC) &_simer_PedigreeCorrector, 10},
    {NULL, NULL, 0}
};

RcppExport void R_init_simer(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
