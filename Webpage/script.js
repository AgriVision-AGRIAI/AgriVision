/* ============================================================
   AgriVision – script.js  (Warm Earthy Theme)
   ============================================================ */

// ---------- Particle Background ----------
(function () {
  const canvas = document.getElementById('bg-canvas');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  let W, H;

  function resize() {
    W = canvas.width  = window.innerWidth;
    H = canvas.height = window.innerHeight;
  }
  resize();
  window.addEventListener('resize', resize);

  const COUNT = window.innerWidth < 768 ? 35 : 70;
  const COLORS = [
    'rgba(111,175,142,0.55)',
    'rgba(77,144,112,0.4)',
    'rgba(139,111,78,0.3)',
    'rgba(242,213,126,0.35)',
    'rgba(47,62,52,0.2)',
  ];

  const particles = [];
  for (let i = 0; i < COUNT; i++) {
    particles.push({
      x: Math.random() * 1920,
      y: Math.random() * 1080,
      r: Math.random() * 1.8 + 0.5,
      dx: (Math.random() - 0.5) * 0.35,
      dy: (Math.random() - 0.5) * 0.28,
      color: COLORS[Math.floor(Math.random() * COLORS.length)],
      alpha: Math.random() * 0.5 + 0.2,
    });
  }

  function draw() {
    ctx.clearRect(0, 0, W, H);
    particles.forEach(p => {
      ctx.beginPath();
      ctx.arc(p.x % W, p.y % H, p.r, 0, Math.PI * 2);
      ctx.fillStyle = p.color;
      ctx.globalAlpha = p.alpha;
      ctx.fill();
      p.x += p.dx;
      p.y += p.dy;
      if (p.x < 0) p.x = W;
      if (p.x > W) p.x = 0;
      if (p.y < 0) p.y = H;
      if (p.y > H) p.y = 0;
    });

    ctx.globalAlpha = 1;
    for (let i = 0; i < particles.length; i++) {
      for (let j = i + 1; j < particles.length; j++) {
        const a = particles[i], b = particles[j];
        const dx = (a.x % W) - (b.x % W);
        const dy = (a.y % H) - (b.y % H);
        const dist = Math.sqrt(dx * dx + dy * dy);
        if (dist < 110) {
          ctx.beginPath();
          ctx.moveTo(a.x % W, a.y % H);
          ctx.lineTo(b.x % W, b.y % H);
          ctx.strokeStyle = `rgba(111,175,142,${0.05 * (1 - dist / 110)})`;
          ctx.lineWidth = 0.5;
          ctx.stroke();
        }
      }
    }
    requestAnimationFrame(draw);
  }
  draw();
})();

// ---------- Sticky Navbar ----------
(function () {
  const navbar = document.getElementById('navbar');
  if (!navbar) return;
  window.addEventListener('scroll', () => {
    navbar.classList.toggle('scrolled', window.scrollY > 40);
  }, { passive: true });
})();

// ---------- Hamburger Menu ----------
(function () {
  const btn  = document.getElementById('hamburger');
  const menu = document.getElementById('mobileMenu');
  if (!btn || !menu) return;
  btn.addEventListener('click', () => {
    const open = menu.classList.toggle('open');
    btn.setAttribute('aria-expanded', open);
  });
  menu.querySelectorAll('a').forEach(a => {
    a.addEventListener('click', () => menu.classList.remove('open'));
  });
})();

// ---------- Scroll Reveal ----------
(function () {
  const targets = document.querySelectorAll('[data-reveal], [data-reveal-right]');
  if (!targets.length) return;
  const obs = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const siblings = [...entry.target.parentElement.querySelectorAll('[data-reveal], [data-reveal-right]')];
        const idx = siblings.indexOf(entry.target);
        setTimeout(() => entry.target.classList.add('visible'), idx * 75);
        obs.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
  targets.forEach(t => obs.observe(t));
})();

// ---------- Smooth CTA scroll ----------
document.querySelectorAll('a[href="#download"]').forEach(a => {
  a.addEventListener('click', e => {
    const section = document.getElementById('download');
    if (section) { e.preventDefault(); section.scrollIntoView({ behavior: 'smooth' }); }
  });
});