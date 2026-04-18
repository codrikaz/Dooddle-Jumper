Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'

function New-Color {
  param(
    [int]$A = 255,
    [int]$R,
    [int]$G,
    [int]$B
  )

  return [System.Drawing.Color]::FromArgb($A, $R, $G, $B)
}

function Add-Ellipse {
  param(
    [System.Drawing.Drawing2D.GraphicsPath]$Path,
    [double]$X,
    [double]$Y,
    [double]$Width,
    [double]$Height
  )

  $Path.AddEllipse([float]$X, [float]$Y, [float]$Width, [float]$Height)
}

function Add-Polygon {
  param(
    [System.Drawing.Drawing2D.GraphicsPath]$Path,
    [object[]]$Points
  )

  $pathPoints = foreach ($point in $Points) {
    [System.Drawing.PointF]::new([float]$point[0], [float]$point[1])
  }

  $Path.AddPolygon($pathPoints)
}

function New-Brush {
  param(
    [System.Drawing.Color]$Color
  )

  return [System.Drawing.SolidBrush]::new($Color)
}

function Fill-GradientEllipse {
  param(
    [System.Drawing.Graphics]$Graphics,
    [double]$X,
    [double]$Y,
    [double]$Width,
    [double]$Height,
    [System.Drawing.Color]$StartColor,
    [System.Drawing.Color]$EndColor,
    [float]$Angle = 90
  )

  $rect = [System.Drawing.RectangleF]::new([float]$X, [float]$Y, [float]$Width, [float]$Height)
  $brush = [System.Drawing.Drawing2D.LinearGradientBrush]::new($rect, $StartColor, $EndColor, $Angle)
  try {
    $Graphics.FillEllipse($brush, $rect)
  } finally {
    $brush.Dispose()
  }
}

function Fill-PathGradient {
  param(
    [System.Drawing.Graphics]$Graphics,
    [System.Drawing.Drawing2D.GraphicsPath]$Path,
    [System.Drawing.Color]$CenterColor,
    [System.Drawing.Color]$SurroundColor
  )

  $brush = [System.Drawing.Drawing2D.PathGradientBrush]::new($Path)
  try {
    $brush.CenterColor = $CenterColor
    $brush.SurroundColors = [System.Drawing.Color[]]@($SurroundColor)
    $Graphics.FillPath($brush, $Path)
  } finally {
    $brush.Dispose()
  }
}

function New-BirdSprite {
  param(
    [string]$OutputPath,
    [ValidateSet('center', 'left', 'right')]
    [string]$Direction,
    [bool]$WithCap = $false
  )

  $width = 781
  $height = 1138
  $bitmap = [System.Drawing.Bitmap]::new($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)

  try {
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $graphics.Clear([System.Drawing.Color]::Transparent)

    $bodyTop = New-Color -R 255 -G 196 -B 151
    $bodyBottom = New-Color -R 249 -G 175 -B 127
    $bellyColor = New-Color -R 255 -G 210 -B 177
    $wingBase = New-Color -R 243 -G 159 -B 106
    $wingGlow = New-Color -A 160 -R 255 -G 210 -B 176
    $maskColor = New-Color -R 226 -G 129 -B 90
    $eyeColor = New-Color -R 36 -G 38 -B 46
    $highlightColor = New-Color -R 255 -G 255 -B 255
    $beakColor = New-Color -R 175 -G 157 -B 140
    $footColor = New-Color -R 240 -G 214 -B 183
    $shadowColor = New-Color -A 35 -R 204 -G 145 -B 109
    $capBase = New-Color -R 132 -G 173 -B 255
    $capLight = New-Color -R 194 -G 217 -B 255

    $bodyRect = [System.Drawing.RectangleF]::new(82.0, 250.0, 617.0, 735.0)
    Fill-GradientEllipse -Graphics $graphics -X $bodyRect.X -Y $bodyRect.Y -Width $bodyRect.Width -Height $bodyRect.Height -StartColor $bodyTop -EndColor $bodyBottom -Angle 90

    $tuft = [System.Drawing.Drawing2D.GraphicsPath]::new()
    try {
      Add-Polygon -Path $tuft -Points @(
        @(360, 118),
        @(303, 232),
        @(403, 232)
      )
      Fill-PathGradient -Graphics $graphics -Path $tuft -CenterColor (New-Color -R 255 -G 204 -B 161) -SurroundColor $bodyTop
    } finally {
      $tuft.Dispose()
    }

    $belly = [System.Drawing.Drawing2D.GraphicsPath]::new()
    try {
      Add-Ellipse -Path $belly -X 149 -Y 390 -Width 485 -Height 545
      Fill-PathGradient -Graphics $graphics -Path $belly -CenterColor $bellyColor -SurroundColor (New-Color -R 255 -G 192 -B 149)
    } finally {
      $belly.Dispose()
    }

    $leftWing = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $rightWing = [System.Drawing.Drawing2D.GraphicsPath]::new()
    try {
      Add-Ellipse -Path $leftWing -X 18 -Y 520 -Width 176 -Height 355
      Add-Ellipse -Path $rightWing -X 587 -Y 520 -Width 176 -Height 355
      Fill-PathGradient -Graphics $graphics -Path $leftWing -CenterColor $wingGlow -SurroundColor $wingBase
      Fill-PathGradient -Graphics $graphics -Path $rightWing -CenterColor $wingGlow -SurroundColor $wingBase
    } finally {
      $leftWing.Dispose()
      $rightWing.Dispose()
    }

    $leftTip = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $rightTip = [System.Drawing.Drawing2D.GraphicsPath]::new()
    try {
      Add-Ellipse -Path $leftTip -X 42 -Y 770 -Width 52 -Height 108
      Add-Ellipse -Path $leftTip -X 89 -Y 798 -Width 48 -Height 117
      Add-Ellipse -Path $rightTip -X 686 -Y 770 -Width 52 -Height 108
      Add-Ellipse -Path $rightTip -X 638 -Y 798 -Width 48 -Height 117
      $wingTipBrush = New-Brush (New-Color -R 244 -G 154 -B 96)
      try {
        $graphics.FillPath($wingTipBrush, $leftTip)
        $graphics.FillPath($wingTipBrush, $rightTip)
      } finally {
        $wingTipBrush.Dispose()
      }
    } finally {
      $leftTip.Dispose()
      $rightTip.Dispose()
    }

    $mask = [System.Drawing.Drawing2D.GraphicsPath]::new()
    try {
      Add-Ellipse -Path $mask -X 112 -Y 410 -Width 255 -Height 265
      Add-Ellipse -Path $mask -X 414 -Y 410 -Width 255 -Height 265
      $maskBrush = New-Brush $maskColor
      try {
        $graphics.FillPath($maskBrush, $mask)
      } finally {
        $maskBrush.Dispose()
      }
    } finally {
      $mask.Dispose()
    }

    $bodyShadow = [System.Drawing.Drawing2D.GraphicsPath]::new()
    try {
      Add-Ellipse -Path $bodyShadow -X 228 -Y 860 -Width 336 -Height 88
      $shadowBrush = New-Brush $shadowColor
      try {
        $graphics.FillPath($shadowBrush, $bodyShadow)
      } finally {
        $shadowBrush.Dispose()
      }
    } finally {
      $bodyShadow.Dispose()
    }

    [double]$centerX = 390.5
    [double]$eyeOffset = 98
    [double]$eyeY = 495
    [double]$pupilW = 62
    [double]$pupilH = 105
    [double]$expressionShiftY = 0
    [double]$mouthTilt = 0

    switch ($Direction) {
      'left' {
        $centerX = 352
        $eyeOffset = 111
        $mouthTilt = -18
      }
      'right' {
        $centerX = 430
        $eyeOffset = 111
        $mouthTilt = 18
      }
      'center' {
        if ($WithCap) {
          $eyeY = 486
          $expressionShiftY = -8
        }
      }
    }

    if ($WithCap) {
      $cap = [System.Drawing.Drawing2D.GraphicsPath]::new()
      $brim = [System.Drawing.Drawing2D.GraphicsPath]::new()
      try {
        Add-Ellipse -Path $cap -X 252 -Y 165 -Width 252 -Height 90
        Add-Polygon -Path $cap -Points @(
          @(293, 217),
          @(340, 146),
          @(468, 146),
          @(500, 218)
        )
        Add-Ellipse -Path $brim -X 236 -Y 212 -Width 284 -Height 44
        Fill-PathGradient -Graphics $graphics -Path $cap -CenterColor $capLight -SurroundColor $capBase
        $brimBrush = New-Brush (New-Color -R 110 -G 151 -B 236)
        try {
          $graphics.FillPath($brimBrush, $brim)
        } finally {
          $brimBrush.Dispose()
        }
      } finally {
        $cap.Dispose()
        $brim.Dispose()
      }
    }

    $leftPupil = [System.Drawing.RectangleF]::new([float]($centerX - $eyeOffset - ($pupilW / 2)), [float]($eyeY + $expressionShiftY), [float]$pupilW, [float]$pupilH)
    $rightPupil = [System.Drawing.RectangleF]::new([float]($centerX + $eyeOffset - ($pupilW / 2)), [float]($eyeY + $expressionShiftY), [float]$pupilW, [float]$pupilH)
    $pupilBrush = New-Brush $eyeColor
    try {
      $graphics.FillEllipse($pupilBrush, $leftPupil)
      $graphics.FillEllipse($pupilBrush, $rightPupil)
    } finally {
      $pupilBrush.Dispose()
    }

    $highlightBrush = New-Brush $highlightColor
    try {
      $graphics.FillEllipse($highlightBrush, [System.Drawing.RectangleF]::new($leftPupil.X + 26, $leftPupil.Y + 4, 30, 39))
      $graphics.FillEllipse($highlightBrush, [System.Drawing.RectangleF]::new($rightPupil.X + 24, $rightPupil.Y + 4, 30, 39))
    } finally {
      $highlightBrush.Dispose()
    }

    if ($WithCap) {
      $sleepLidBrush = New-Brush (New-Color -A 70 -R 255 -G 238 -B 225)
      try {
        $graphics.FillPie($sleepLidBrush, [float]$leftPupil.X, [float]$leftPupil.Y - 3, [float]$leftPupil.Width, [float]($leftPupil.Height * 0.72), 0, 180)
        $graphics.FillPie($sleepLidBrush, [float]$rightPupil.X, [float]$rightPupil.Y - 3, [float]$rightPupil.Width, [float]($rightPupil.Height * 0.72), 0, 180)
      } finally {
        $sleepLidBrush.Dispose()
      }
    }

    $beak = [System.Drawing.Drawing2D.GraphicsPath]::new()
    try {
      [double]$beakCenterX = $centerX + $mouthTilt
      Add-Polygon -Path $beak -Points @(
        @(($beakCenterX - 58), 686),
        @($beakCenterX, 601),
        @(($beakCenterX + 58), 686),
        @($beakCenterX, 770)
      )
      Fill-PathGradient -Graphics $graphics -Path $beak -CenterColor (New-Color -R 190 -G 174 -B 158) -SurroundColor $beakColor
    } finally {
      $beak.Dispose()
    }

    $feetBrush = New-Brush $footColor
    try {
      foreach ($x in 272, 309, 447, 484) {
        $graphics.FillEllipse($feetBrush, [System.Drawing.RectangleF]::new([float]$x, 950, 44, 76))
      }
      $graphics.FillRectangle($feetBrush, 286, 930, 47, 78)
      $graphics.FillRectangle($feetBrush, 461, 930, 47, 78)
    } finally {
      $feetBrush.Dispose()
    }

    $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
  } finally {
    $graphics.Dispose()
    $bitmap.Dispose()
  }
}

$assetRoot = Join-Path $PSScriptRoot '..\assets\images\game'

New-BirdSprite -OutputPath (Join-Path $assetRoot 'dash_center.png') -Direction center
New-BirdSprite -OutputPath (Join-Path $assetRoot 'dash_left.png') -Direction left
New-BirdSprite -OutputPath (Join-Path $assetRoot 'dash_right.png') -Direction right
New-BirdSprite -OutputPath (Join-Path $assetRoot 'dash_hat_center.png') -Direction center -WithCap $true
New-BirdSprite -OutputPath (Join-Path $assetRoot 'dash_hat_left.png') -Direction left -WithCap $true
New-BirdSprite -OutputPath (Join-Path $assetRoot 'dash_hat_right.png') -Direction right -WithCap $true
