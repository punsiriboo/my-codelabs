
id: vibe-coding-line-mini-app
title: Vibe Coding LINE MINI App with AI Studio
summary: Codelab นี้สอนการสร้างเว็บจองร้านอาหาร แปลงเป็น LINE MINI App และส่ง Service Message ทั้งหมดด้วย Prompt ใน Google AI Studio
authors: Punsiri Boonyakiat
categories: LINE MINI App, AI Studio
tags: LINE MINI App, AI Studio, Vibe Coding, Service Message
status: Published
url: vibe-coding-line-mini-app
Feedback Link: https://forms.gle/xXkqeFE3vLSubP1f9

# Vibe Coding LINE MINI App with AI Studio

## บทนำ
Duration: 0:05:00

"ถ้าคุณมีเว็บไซต์ที่ใช้งานอยู่แล้ว — หรือสร้างเว็บจองร้านอาหารจาก Prompt ใน Google AI Studio — คุณสามารถ **แปลงเว็บให้เป็น LINE MINI App** ด้วยการ Prompt ใน Google AI Studio ได้"

Codelab นี้ออกแบบสำหรับ Workshop แบบ Hands-on เริ่มจาก **Prompt สร้างเว็บจองร้านอาหาร** ใน Google AI Studio จากนั้น **แปลงเว็บให้เป็น LINE MINI App** ด้วย Google AI Studio ทุกขั้นตอนทำผ่านการ **ใส่ Prompt ใน AI Studio**:
![LINE Messaging API](img/title.png)

### สิ่งที่คุณจะได้ลงมือทำ

- สร้าง **Provider** และ **LINE MINI App Channel** ใน [LINE Developers Console](https://developers.line.biz/console/)
- สร้างเว็บจองร้านอาหาร (Restaurant Reservation) ด้วย Prompt ใน [Google AI Studio](https://aistudio.google.com/)
- แปลงเว็บให้เป็น LINE MINI App ด้วย Prompt ใน Google AI Studio
- ดึงข้อมูล LINE User Profile มาแสดงบนหน้า MINI App ผ่านการเขียน Prompt
- แชร์การจองให้เพื่อนหรือกลุ่มด้วย **Share Target Picker** ผ่าน Prompt
- ตั้งค่า Service Message Template และส่งการยืนยันการจองโต๊ะหลังผู้ใช้กด Reserve Now

### สิ่งที่คุณจะได้เรียนรู้

- **Vibe Coding**: แนวคิดและข้อดีของการสร้างแอปจาก Prompt
- **Google AI Studio Build Mode**: สร้างและ Deploy เว็บจองร้านอาหารจาก Prompt
- **LINE MINI App**: สร้าง Provider, Channel และตั้งค่า LIFF, Endpoint URL
- **Share Target Picker**: แชร์ข้อความการจองไปยังเพื่อนหรือกลุ่มใน LINE
- **Service Message**: ส่งการแจ้งเตือนยืนยันให้ผู้ใช้ใน LINE ผ่าน LINE MINI App Service Message

### สิ่งที่คุณต้องเตรียมพร้อมก่อนเริ่ม Codelab
- **แอปพลิเคชัน LINE บนสมาร์ทโฟน** ที่เข้าสู่ระบบเรียบร้อยแล้ว
- [**บัญชี Google**](https://accounts.google.com/signup) – สำหรับ Google AI Studio
- [**บัญชี LINE Developers**](https://developers.line.biz/console/) – สำหรับสร้าง LINE MINI App Channel
- **เบราว์เซอร์ Chrome หรือ Edge** บนคอมพิวเตอร์


## ทำความรู้จัก Vibe Coding และ AI Studio
Duration: 0:15:00

### Vibe Coding คืออะไร?

**Vibe Coding** (ไวบ์ โค้ดดิ้ง) คือแนวทางการพัฒนาแอปพลิเคชันโดย **อธิบาย "สิ่งที่ต้องการ" ด้วยภาษาธรรมชาติ (Prompt)** แล้วให้ AI สร้าง UI, Logic และการเชื่อมต่อระบบให้แทน — ไม่ต้องเริ่มจากการเขียนโค้ดทีละบรรทัด

คำว่า *Vibe* หมายถึงการสื่อสาร **"ความรู้สึก" หรือ "เป้าหมาย"** ของแอปที่ต้องการ เช่น "อยากได้เว็บจองร้านอาหารแบบ Premium สีเขียว ใช้งานง่ายบนมือถือ" แทนที่จะระบุ HTML, CSS หรือ JavaScript ทีละไฟล์


### Tools ยอดนิยมสำหรับ Vibe Coding

ปัจจุบันมีเครื่องมือ Vibe Coding หลายตัวที่ได้รับความนิยม แต่ละตัวมีจุดเด่นต่างกัน:

| เครื่องมือ | จุดเด่น | เหมาะกับ |
|:---|:---|:---|
| [Google AI Studio](https://aistudio.google.com/) | สร้าง Full-stack App จาก Prompt, Deploy ได้ทันที | Web App, Prototype, Demo |
| [Cursor](https://cursor.com/) | AI-powered IDE ช่วยเขียนและแก้โค้ดในโปรเจกต์จริง | Developer ที่ต้องการควบคุมโค้ดมากขึ้น |
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | AI Agent ทำงานใน Terminal / IDE | Automation, Refactoring, CLI workflow |
| [Windsurf](https://windsurf.com/) | AI IDE เน้น Flow การพัฒนาแบบ Agentic | Full-stack development |
| [Bolt.new](https://bolt.new/) | สร้าง Web App ใน Browser จาก Prompt | Prototype เร็ว, Full-stack demo |

<aside class="positive">
<strong>Note:</strong> ใน Workshop นี้เราใช้ <strong>Google AI Studio</strong> สร้างเว็บจองร้านอาหาร และแปลงเป็น LINE MINI App — แต่หลักการ Vibe Coding ใช้ได้กับเครื่องมืออื่นๆ ด้านบนเช่นกัน
</aside>

### ข้อดีของ Vibe Coding

| ข้อดี | รายละเอียด |
|:---|:---|
| **Prototype ได้เร็วมาก** | จากที่เคยใช้หลายวัน เหลือไม่กี่ชั่วโมง |
| **คนที่ไม่ใช่ Developer ก็สร้าง App ได้** | Product Owner, Designer หรือ Entrepreneur ลองสร้าง MVP เองได้ |
| **เหมาะกับ MVP, Hackathon, Demo** | ทดสอบไอเดียและ pitch ได้เร็วก่อนลงมือพัฒนาจริงจัง |
| **สร้าง UI ได้เร็วมาก** | อธิบาย Style, Layout, Flow แล้วให้ AI generate ให้ทันที |

## สร้างเว็บจองร้านอาหาร

Duration: 0:45:00

ในช่วงนี้คุณจะใช้ **Google AI Studio** สร้างเว็บจองร้านอาหารแบบ ด้วย Prompt — ไม่ต้องเขียนโค้ดเอง

### ขั้นตอนที่ 1: เปิด Google AI Studio

1. ไปที่ [Google AI Studio](https://aistudio.google.com/)
2. เข้าสู่ระบบด้วยบัญชี Google
3. คลิก **Build** เพื่อเริ่มโปรเจกต์ใหม่

### ขั้นตอนที่ 2: Prompt สร้างเว็บจองร้านอาหาร (Copy & Paste)

วาง Prompt ด้านล่างนี้ใน Google AI Studio แล้วกด **Generate**:

```
Create a modern mobile-first restaurant reservation app inspired by premium dining reservation experiences.

Design Style:
- Clean, elegant, and minimal
- White background
- Soft gray cards and borders
- Green accent color (#00C853)
- Spacious layout
- Large touch-friendly controls
- Premium restaurant feel
- Suitable for LINE MINI App

Reservation Flow:

1. Guest Selector Card
- Display "Number of Guests"
- Plus/Minus button
- Default value = 2

2. Dining Date Section
- Section title: "Select Dining Date"
- Horizontal date picker cards
- Today highlighted in green
- Display selected full date above the date cards

3. Preferred Time Section
- Section title: "Select Preferred Time"

Lunch Slots: every half hour from 11:30 - 14:00
Dinner Slots: every half hour from 17:30 - 21:00
Display each time slot as rounded selectable buttons.

Selected state:
- Green background
- White text

4. Customer Details Section
Fields:
- Full Name
- Mobile Number
- Special Request (optional)

Functionality:
- Users select date, time, enter customer details, tap Reserve Now

Implement one mock function: createReservation() via Server API
```

<aside class="positive">
<strong>Tip:</strong> ถ้า UI ยังไม่ตรงใจ ให้ใช้ **Annotation Mode** วาดวงรอบส่วนที่ต้องการแก้ แล้ว Prompt เพิ่ม เช่น "เปลี่ยนชื่อร้านเป็น The Green Table" หรือ "เพิ่มโลโก้ร้านด้านบน"
</aside>

### ขั้นตอนที่ 3: Prompt เพื่อปรับปรุงเว็ป

```
Add the restaurant name "The Green Table" and a tagline at the top of the page.
Display a sample menu in a carousel format.
Use high-quality food images and show the dish name, short description, and price for each menu item.
Keep the design clean, modern, and mobile-friendly.
```

### ขั้นตอนที่ 4: Deploy เว็บ (optional)

เมื่อ Preview ใช้งานได้แล้ว ให้ Deploy เพื่อได้ URL สาธารณะ:

1. คลิก **Deploy** ใน Google AI Studio
2. เลือก Deploy ไปยัง **Google Cloud Run** (หรือตัวเลือกที่ AI Studio แนะนำ)
3. รอจน Deploy สำเร็จ แล้ว **คัดลอก URL** ไว้ใช้ในขั้นตอนถัดไป


### ทดสอบเว็บก่อนไปต่อ
- [ ] เลือกจำนวนแขก (+ / −) ได้
- [ ] เลือกวันที่และช่วงเวลา (Lunch / Dinner) ได้
- [ ] กรอกชื่อ เบอร์โทร และ Special Request ได้
- [ ] กด Reserve Now แล้วเห็น Summary / Confirmation




## สร้าง Provider และ Channel
Duration: 0:20:00

ก่อนสร้างเว็บและแปลงเป็น LINE MINI App คุณต้องมี **Provider** และ **LINE MINI App Channel** ใน [LINE Developers Console](https://developers.line.biz/console/) ก่อน

### สมัครเป็น LINE Developer

จุดเริ่มต้นสำหรับการพัฒนาแอปพลิเคชันต่างๆ บนแพลตฟอร์มของ LINE คือคุณจะต้องสมัครเป็น **LINE Developer** ก่อน

1. เข้าไปที่ [https://developers.line.biz/console/](https://developers.line.biz/console/) แล้วเลือก **Log in with LINE account** (สีเขียว) เพื่อเข้าสู่ระบบ
2. เข้าสู่ระบบด้วยบัญชี LINE ของคุณให้เรียบร้อย
3. กรอกชื่อและอีเมล พร้อมกดยอมรับ Agreement จากนั้นกดปุ่ม **Create my account** — เสร็จสิ้นขั้นตอนการสมัครเป็น LINE Developer

### สร้าง Provider

**Provider** คือ superset ของแอปทั้งหลายที่เราจะพัฒนาขึ้น รวมถึง LINE MINI App ด้วย โดยการสร้างเพียงให้ระบุชื่อของ Provider ลงไป ซึ่งอาจจะตั้งเป็นชื่อตัวเอง, ชื่อบริษัท, ชื่อทีม หรือชื่อกลุ่มก็ได้

1. ในหน้า Console คลิก **Create a new provider**
2. ระบุชื่อ Provider แล้วกด **Create**

<aside class="negative">
<strong>Important:</strong> 1 Account สามารถมี Provider สูงสุดได้ 10 Providers และ<strong>ไม่สามารถมีคำว่า LINE ในชื่อ Provider</strong> ได้
</aside>

### สร้าง Channel

**Channel** คือ subset ของ Provider ซึ่งเปรียบเสมือนแอปพลิเคชัน

ใน Codelab นี้เราจะต้องเลือก **Create a LINE MINI App channel**

1. เลือก Provider ที่สร้างไว้ → คลิก **Create a new channel**
2. เลือก **LINE MINI App**
3. กรอกรายละเอียด Channel:
   - **Channel name**: `Restaurant Reservation`
   - **Channel description**: `บริการจองโต๊ะร้านอาหาร The Green Table`
   - **Category**: เลือกหมวดที่เหมาะสม (เช่น Food & Drink)
4. กดสร้าง Channel

<aside class="positive">
<strong>Note:</strong> ส่วนของ Channel icon และ Terms of Use สามารถระบุภายหลังได้
</aside>

บันทึก **Channel ID** และ **LIFF ID** จากแท็บ **Web app settings** ไว้ใช้ในขั้นตอนถัดไป


## แปลงเว็บเป็น LINE MINI App
Duration: 0:45:00

ในช่วงนี้คุณจะใช้ **Google AI Studio** เพื่อ **แปลงเว็บที่มีอยู่แล้ว** ให้ทำงานเป็น **LINE MINI App** ผ่าน LIFF — ทุกขั้นตอนทำด้วย Prompt

<aside class="positive">
<strong>Note:</strong> ใช้ Channel <strong>Restaurant Reservation</strong> ที่สร้างไว้ในขั้นตอน <strong>สร้าง Provider และ Channel</strong> — ตรวจสอบว่ามี Channel ID และ LIFF ID จากแท็บ <strong>Web app settings</strong> แล้ว
</aside>

### ขั้นตอนที่ 1: Prompt เพื่อแปลงเป็น LINE MINI App และสร้าง LINE User Profile Card

ไปยัง LINE Developer Console เพื่อ หา LIFF_ID


หลัง AI สร้างแอปแล้ว ให้ Prompt สร้าง **User Profile Card** ที่ดึงข้อมูลจาก LINE (แทนที่ `YOUR_LIFF_ID` ด้วย LIFF ID จาก Console):

```
Convert my existing restaurant reservation website into a LINE MINI App.

Do not redesign or rebuild the website from scratch. Preserve the existing UI, pages, user flow, styling, and business logic as much as possible.

Add LINE Login and LIFF integration using:

LIFF ID: YOUR_LIFF_ID

Requirements:

Add a LINE User Profile Card at the top of the reservation page.
Display the user's LINE profile picture and display name.
Automatically populate the customer name field with the user's LINE display name.
Keep the customer name field editable.
Support automatic LINE Login when users open the MINI App from an external browser (Chrome, Safari, desktop browser, etc.).
Detect whether the app is running inside the LINE application or in an external browser.
Retrieve LINE environment information for app behavior and debugging purposes.
If the LINE profile cannot be loaded, the reservation form must continue working normally without blocking the reservation process.
Keep all existing reservation functionality unchanged.
Maintain the current UI and user experience while adding LINE MINI App capabilities.
```


### ขั้นตอนที่ 2: ตั้งค่า LINE MINI App

หลังจากที่คุณมี **Provider** และ **LINE MINI App channel** เรียบร้อยแล้ว ขั้นตอนต่อไปเราจะมาตั้งค่าเพื่อใช้งาน LINE MINI App กัน

1. ไปที่ [LINE Developers Console](https://developers.line.biz/console/)
2. เลือก Channel **Restaurant Reservation**
3. เปิดแท็บ **Web app settings**

#### ผูก Endpoint URL เข้ากับ LINE MINI App

**Endpoint URL** คือ URL ที่รองรับ **HTTPS** ซึ่ง LINE จะใช้โหลดเว็บแอปของคุณเมื่อผู้ใช้เปิด MINI App

ใน Codelab นี้ ให้คุณระบุ **Endpoint URL ของเว็บที่ Deploy แล้วจาก Google AI Studio** ลงในช่อง **Developing**:

1. แท็บ **Web app settings** → หา **Endpoint URL**
2. วาง URL ของเว็บจองร้านอาหารที่ Deploy แล้ว (ต้องขึ้นต้นด้วย `https://`)
3. คลิก **Update** เพื่อบันทึก

#### LIFF URL สำหรับเปิด MINI App

URL ของ LINE MINI App ที่เราจะนำไปใช้ทดสอบจะอยู่ที่ **LIFF URL** แบบ **Developing** ในหน้า **Web app settings** เช่น:

```
https://miniapp.line.me/xxxxxxxxxx-xxxxxxxx
```

<aside class="negative">
<strong>Important:</strong> URL ของ LINE MINI App ในขั้นตอนนี้ให้ทดสอบบน <strong>แอป LINE บนสมาร์ทโฟน</strong> และ <strong>External Browser บนมือถือ</strong> ก่อน — การรองรับ PC/Desktop จะตั้งค่าเพิ่มในขั้นตอนถัดไป
</aside>

<aside class="positive">
<strong>Note:</strong> สิ่งที่ตามหลัง <code>https://miniapp.line.me/</code> ทั้งหมดคือสิ่งที่เรียกว่า <strong>LIFF ID</strong> ซึ่งใช้ในการ initialize LIFF SDK เช่น <code>2007775907-73PXWwvy</code> — คัดลอก LIFF ID นี้ไว้ใช้ใน Prompt ขั้นตอนถัดไป
</aside>


## ส่งและแชร์ข้อความ
Duration: 0:15:00

**Share Target Picker** เป็นฟีเจอร์ของ LIFF ที่ให้ผู้ใช้เลือก **เพื่อนหรือกลุ่ม** ใน LINE เพื่อแชร์ข้อความจาก MINI App ได้ — เหมาะกับ Use Case ชวนเพื่อนมาร่วมจองโต๊ะที่ร้าน

<aside class="negative">
<strong>Important:</strong> Share Target Picker ใช้งานได้เมื่อเปิด MINI App ผ่าน <strong>แอป LINE บนสมาร์ทโฟน</strong> เท่านั้น — ตรวจสอบด้วย <code>liff.isApiAvailable('shareTargetPicker')</code> ก่อนแสดงปุ่ม
</aside>

อ้างอิง: [Sharing targets with Share Target Picker](https://developers.line.biz/en/docs/liff/sharing-target-picker/)

### Prompt Share Target Picker (Copy & Paste)

วาง Prompt นี้ใน Google AI Studio หลัง MINI App และ User Profile Card ใช้งานได้แล้ว:

```
Add Share Target Picker to the Restaurant Reservation LINE MINI App

Requirements:
1. Add a "Share to Friends" button on the reservation confirmation / summary screen
2. Show the button only when liff.isApiAvailable('shareTargetPicker') is true
   - Short invitation text in Thai, e.g. "มาร่วมจองโต๊ะกับฉันที่ The Green Table"
```

### ทดสอบ Share Target Picker

- [ ] เปิด MINI App ผ่านแอป LINE บนมือถือ
- [ ] จองโต๊ะสำเร็จแล้วเห็นปุ่ม **Share to Friends**
- [ ] กดปุ่มแล้วเลือกเพื่อนหรือกลุ่มได้
- [ ] ข้อความที่แชร์แสดงวัน เวลา และจำนวนแขกถูกต้อง
- [ ] ปุ่มไม่แสดง (หรือ disabled) เมื่อเปิดจาก External Browser


## เพิ่ม Template ของ Service Messages
Duration: 0:30:00

### Service Message คืออะไร?

**Service Message** เป็นฟีเจอร์ของ LINE MINI App ที่ช่วยส่ง **การแจ้งเตือนที่เกี่ยวข้องกับการกระทำของผู้ใช้** ไปยังแชท **LINE MINI App Notice** (ประเทศไทย)

ตัวอย่าง Use Case สำหรับ Restaurant Reservation:
- ยืนยันการจองโต๊ะสำเร็จ
- แจ้งเตือนก่อนถึงเวลารับประทาน 1 วัน
- แจ้งยกเลิกการจอง



### ขั้นตอนที่ 1: เพิ่ม Template ของ Service Messages

ขั้นตอนต่อไปเราจะมาสร้าง Template ของข้อความกัน โดยใน Channel ให้เราเลือกแท็บ **Service message template** แล้วกดปุ่ม **Add** สีเขียวทางด้านขวาล่าง

1. ไปที่ [LINE Developers Console](https://developers.line.biz/console/)
2. เลือก Channel **Restaurant Reservation** (Developing)
3. เปิดแท็บ **Service message template**
4. คลิกปุ่ม **Add** (สีเขียว มุมขวาล่าง)

#### เพิ่ม Template ที่ต้องการ

ให้เลือก Template ที่ต้องการ โดยจะต้องเลือก **Category**, **Language**, และ **Template name** — เมื่อเลือกแล้วเราจะได้ **Template name สำหรับนำไปใช้กับ API** ในขั้นตอนต่อไป

สำหรับ Codelab นี้ แนะนำให้เลือก:
- **Category**: Store reservation หรือ Booking confirmation
- **Language**: Thai
- **Template name**: เลือก Template ที่เหมาะกับการยืนยันการจองโต๊ะ

<aside class="positive">
<strong>Tip:</strong> จด **Template name for API use** ไว้ทันที (รูปแบบ <code>{template_name}_th</code>) — จะใช้ใน Prompt และ API ขั้นตอนถัดไป
</aside>

#### ทดสอบส่งข้อความด้วยตัวแปร (Template Variables)

ถัดลงมาในหน้าเดียวกัน เราจะพบกับส่วนของ **ตัวแปร (Template Variables)** ที่จะเอาไว้ใช้กับ API โดยที่เราสามารถทดสอบส่งข้อความได้


<aside class="negative">
<strong>Important:</strong> การส่งข้อความด้วย Service Messages จะสามารถเลือกประเภทของข้อความได้<strong>ตาม Template ที่ทาง LINE เตรียมไว้ให้เท่านั้น</strong>
</aside>


## Implement Service Message ใน MINI App
Duration: 0:45:00

ในช่วงนี้คุณจะใช้ **Prompt ใน Google AI Studio** เพื่อ Implement การส่ง Service Message หลังจองสำเร็จ

### ขั้นตอนที่ 1: Prompt สร้าง Backend สำหรับ Service Message API

```
Implement server-side Service Message API for Restaurant Reservation MINI App.

Requirements:
Create a function that sends a LINE Service Message after a reservation is successfully created.

Flow:
- Issue Stateless Channel Access Token
- Issue Service Notification Token using LIFF Access Token
- Send Service Message using template book_request_s_b_th

Environment variables needed:
   - LINE_CHANNEL_ID: 
   - LINE_CHANNEL_SECRET: 

Send Service Message with "templateParams": { "number": "xx", "btn1_url": "https://line.me", "btn2_url": "https://line.me", "btn3_url": "https://line.me", "btn4_url": "https://line.me" }

Update Restaurant Reservation MINI App frontend to send service message after successful reservation
```

<aside class="negative">
<strong>Important:</strong> ใช้ **Stateless Channel Access Token** สำหรับ LINE MINI App — ห้ามใช้ Long-lived token
</aside>


### Checklist ทดสอบ Service Message
- [ ] Template ถูก Add ใน Console แล้ว
- [ ] Test Message จาก Console Preview ส่งได้
- [ ] จองโต๊ะใน MINI App แล้วได้รับ Service Message
- [ ] ข้อมูลใน Message ตรงกับการจอง (วัน, เวลา, จำนวนแขก)




## Congratulations
Duration: 0:05:00

ยินดีด้วยครับ ถึงตรงนี้คุณก็มี LINE MINI App ตัวแรกเป็นของคุณเองแล้ว!!!

### สิ่งที่คุณได้เรียนรู้ใน Codelab นี้

✅ การสร้าง Provider และ LINE MINI App Channel ใน LINE Developers Console  
✅ การสร้างเว็บจองร้านอาหารด้วย Vibe Coding ใน Google AI Studio  
✅ การแปลงเว็บธรรมดาให้กลายเป็น LINE MINI App ด้วย Prompt  
✅ การดึงข้อมูลผู้ใช้งาน LINE (User Profile) ด้วย Prompt  
✅ การแชร์ข้อความไปยังเพื่อนหรือกลุ่มด้วย Share Target Picker ผ่าน Prompt  
✅ การตั้งค่า Service Message Template ใน LINE Developers Console  
✅ การส่ง Service Message ยืนยันการจองด้วย Prompt ใน Google AI Studio  

### เรียนรู้เพิ่มเติม

- [บทความเกี่ยวกับ LINE MINI App ใน LINE Developers Thailand](https://medium.com/linedevth/tagged/line-mini-app)

### Reference docs

- [LINE MINI App Quickstart](https://developers.line.biz/en/docs/line-mini-app/quickstart/)
- [Google AI Studio](https://aistudio.google.com/)
- [LINE MINI App Documentation](https://developers.line.biz/en/docs/line-mini-app/)
- [Sending service messages](https://developers.line.biz/en/docs/line-mini-app/develop/service-messages/)
- [Open MINI App in external browser](https://developers.line.biz/en/docs/line-mini-app/develop/external-browser/)
- [Share Target Picker](https://developers.line.biz/en/docs/liff/sharing-target-picker/)
- [LINE MINI App API Reference](https://developers.line.biz/en/reference/line-mini-app/)

### บอกเราหน่อยว่า Codelab ชุดนี้เป็นอย่างไรบ้าง

- [Feedback form](https://forms.gle/xXkqeFE3vLSubP1f9)
