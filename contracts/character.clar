;; Character attributes and stats
(define-non-fungible-token character uint)

(define-map character-stats uint {
  name: (string-utf8 24),
  level: uint,
  experience: uint,
  health: uint,
  attack: uint,
  defense: uint
})

(define-data-var next-character-id uint u1)

;; Create new character
(define-public (create-character (name (string-utf8 24)))
  (let ((character-id (var-get next-character-id)))
    (try! (nft-mint? character character-id tx-sender))
    (map-set character-stats character-id {
      name: name,
      level: u1,
      experience: u0,
      health: u100,
      attack: u10,
      defense: u5
    })
    (var-set next-character-id (+ character-id u1))
    (ok character-id)))

;; Get character stats
(define-read-only (get-character-stats (character-id uint))
  (map-get? character-stats character-id))
