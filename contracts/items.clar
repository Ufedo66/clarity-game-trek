;; Game items as NFTs
(define-non-fungible-token item uint)

(define-map item-details uint {
  name: (string-utf8 24),
  item-type: (string-utf8 12),
  power: uint,
  level-req: uint
})

(define-data-var next-item-id uint u1)

;; Mint new item
(define-public (mint-item (name (string-utf8 24)) 
                         (item-type (string-utf8 12))
                         (power uint)
                         (level-req uint))
  (let ((item-id (var-get next-item-id)))
    (try! (nft-mint? item item-id tx-sender))
    (map-set item-details item-id {
      name: name,
      item-type: item-type,
      power: power,
      level-req: level-req
    })
    (var-set next-item-id (+ item-id u1))
    (ok item-id)))

;; Get item details
(define-read-only (get-item-details (item-id uint))
  (map-get? item-details item-id))
