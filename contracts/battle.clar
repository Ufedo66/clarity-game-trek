;; Battle system mechanics
(define-map monsters uint {
  name: (string-utf8 24),
  health: uint,
  attack: uint,
  defense: uint,
  exp-reward: uint
})

;; Initialize monster data 
(define-private (initialize-monsters)
  (begin
    (map-set monsters u1 {
      name: "Goblin",
      health: u50,
      attack: u5,
      defense: u3,
      exp-reward: u10
    })
    (ok true)))

;; Calculate damage based on attack and defense
(define-private (calculate-damage (attacker-power uint) (defender-defense uint))
  (let ((damage (- attacker-power defender-defense)))
    (if (< damage u1)
      u1
      damage)))

;; Battle monster
(define-public (battle-monster (character-id uint) (monster-id uint))
  (let ((char-stats (unwrap! (get-character-stats character-id) (err u404)))
        (monster (unwrap! (map-get? monsters monster-id) (err u404))))
    (let ((damage-to-monster (calculate-damage (get attack char-stats) (get defense monster)))
          (damage-to-char (calculate-damage (get attack monster) (get defense char-stats))))
      
      ;; Update character stats after battle
      (let ((new-health (- (get health char-stats) damage-to-char))
            (new-exp (+ (get experience char-stats) (get exp-reward monster))))
        
        (map-set character-stats character-id 
          (merge char-stats {
            health: new-health,
            experience: new-exp
          }))
        
        (ok {
          damage-dealt: damage-to-monster,
          damage-taken: damage-to-char,
          exp-gained: (get exp-reward monster)
        })))))
