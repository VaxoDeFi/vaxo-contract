
;; title: vaxo
;; version:
;; summary:
;; description: Vaxo Token Contract 

;; Implement the `ft-trait` trait defined in the `ft-trait` contract
;; https://github.com/hstove/stacks-fungible-token
(impl-trait .ft-trait.sip-010-trait)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant token-supply u100000000)
(define-constant token-decimals u6)
(define-constant token-uri none)
(define-constant name "VAXO")
(define-constant symbol "VAXO")

(define-fungible-token vaxo token-supply)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
	(begin
		(asserts! (is-eq tx-sender sender) err-not-token-owner)
		(try! (ft-transfer? vaxo amount sender recipient))
		(match memo to-print (print to-print) 0x)
		(ok true)
	)
)

(define-public (buy (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
	(begin
		(asserts! (is-eq tx-sender sender) err-not-token-owner)
		(try! (ft-transfer? vaxo amount sender recipient))
		(match memo to-print (print to-print) 0x)
		(ok true)
	)
)

(define-read-only (get-name)
	(ok name)
)

(define-read-only (get-symbol)
	(ok symbol)
)

(define-read-only (get-decimals)
	(ok token-decimals)
)

(define-read-only (get-balance (who principal))
	(ok (ft-get-balance vaxo who))
)

(define-read-only (get-total-supply)
	(ok (ft-get-supply vaxo))
)

(define-read-only (get-token-uri)
	(ok token-uri)
)

(define-public (mint (amount uint) (recipient principal))
	(begin
		(asserts! (is-eq tx-sender contract-owner) err-owner-only)
		(ft-mint? vaxo amount recipient)
	)
)

;; Mint this token to a few people when deployed
;; (ft-mint? vaxo u12345 'ST3J2GVMMM2R07ZFBJDWTYEYAR8FZH5WKDTFJ9AHA)
;; (ft-mint? vaxo u12345 'ST1TWA18TSWGDAFZT377THRQQ451D1MSEM69C761)
;; (ft-mint? vaxo u12345 'ST50GEWRE7W5B02G3J3K19GNDDAPC3XPZPYQRQDW)
