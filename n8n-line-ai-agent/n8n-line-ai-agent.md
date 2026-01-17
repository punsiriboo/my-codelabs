
id: n8n-line-ai-agent
title: Build a Smart AI Chatbot without Coding using n8n
summary: Codelab นี้คุณจะได้เรียนรู้การสร้าง LINE AI Chatbot แบบ Step-by-Step โดยใช้ n8n เป็น Webhook Server เชื่อมต่อ Generative AI อย่าง Gemini เพื่อให้บอทเข้าใจภาษาและตอบโต้ได้เองอย่างชาญฉลาด โดยทั้งหมดนี้ไม่ต้องเขียนโค้ด
authors: Punsiri Boonyakiat
categories: LINE Messaging API, LINE Chatbot
tags: LINE Messaging API, LINE Chatbot
status: Published
url: n8n-line-ai-agent
Feedback Link: https://forms.gle/xXkqeFE3vLSubP1f9


# Build a Smart AI Chatbot without Coding using n8n


## บทนำ
Duration: 0:05:00

![Title](images/1.1.png)

"ในยุคที่ AI เข้ามามีบทบาทสำคัญ การสร้าง Chatbot ที่ 'ฉลาด' และ 'เข้าใจบริบท' ไม่จำเป็นต้องเขียนโค้ดที่ซับซ้อนอีกต่อไป"

ใน Codelab นี้ คุณจะได้เรียนรู้วิธีสร้าง LINE AI Chatbot แบบ Step-by-Step และที่สำคัญคือไม่ต้องเขียนโค้ดโดยใช้ Technology Stack ที่ทรงพลังและเริ่มต้นได้ฟรี:

- LINE: แพลตฟอร์มแชทที่เราคุ้นเคย ทำหน้าที่เป็นหน้าบ้าน (User Interface) สำหรับรับ-ส่งข้อความกับผู้ใช้งาน
- Google Gemini: ทำหน้าที่เป็น "สมอง" ในการประมวลผลภาษาและคิดคำตอบ
- n8n (Workflow Automation): เครื่องมือ Low-Code เพื่อเชื่อมต่อระบบต่างๆ เข้าด้วยกัน
- Render: Cloud Hosting สำหรับรัน n8n (Deployment)


### สิ่งที่คุณจะได้ลงมือทำ
- Deploy n8n ขึ้นบน Cloud (Render) ฟรี
- เชื่อมต่อ LINE Official Account เข้ากับ n8n
- สร้าง Workflow รับส่งข้อความอัตโนมัติ
- เชื่อมต่อ Google Gemini เพื่อให้บอทตอบคำถามได้อย่างเป็นธรรมชาติ

### สิ่งที่คุณจะได้เรียนรู้
- เข้าใจระบบ: เรียนรู้หลักการทำงานของ LINE Messaging API และ AI Automation
- เตรียมความพร้อม: สร้าง LINE OA และตั้งค่า Messaging API ให้พร้อมใช้งาน
- ติดตั้งเครื่องมือ: รู้จัก n8n และวิธี Deploy แบบ Self-hosted บน Render
- เชื่อมต่อ: สร้าง Webhook ด้วย n8n เพื่อรับ-ส่งข้อความกับผู้ใช้
- สร้างบอท: พัฒนา AI Chatbot ตัวแรกบน LINE ที่ใช้งานได้จริง
- ปรับแต่ง AI: เทคนิคการเขียนคำสั่ง (System Prompt) ให้ AI เข้าใจบริบทและตอบโจทย์ธุรกิจ

### สิ่งที่คุณต้องเตรียมพร้อมก่อนเริ่ม Codelab 

- **แอปพลิเคชัน LINE บนสมาร์ทโฟน** ที่เข้าสู่ระบบเรียบร้อยแล้ว – สำหรับใช้สร้างและจัดการ LINE Official Account

- [**บัญชี Google**](https://accounts.google.com/signup) – สำหรับเข้าใช้งาน Google AI Studio เพื่อกดรับ Gemini API Key ในการเชื่อมต่อกับ AI

- **[บัญชี Render (สมัครฟรี)](https://dashboard.render.com/register)** – สำหรับใช้เป็น Server ในการ Deploy และรัน n8n



## ทำความรู้จักกับ LINE Messaging API
Duration: 0:10:00

### LINE Messaging API คืออะไร?
**LINE Messaging API** คือ API ที่ให้บริการโดย LINE Corporation ที่จะทำหน้าที่เป็นตัวกลางที่จะเชื่อมต่อ Server ของเราเข้ากับ LINE Official Account ทำให้เราสามารถเขียนโปรแกรมเพื่อสร้างบริการที่เราต้องการ ผ่านการข้อความและโต้ตอบกับผู้ใช้ในลักษณะ Chatbot ได้นั่นเอง โดยสามารถโต้ตอบกับผู้ใช้หลักๆ ได้ 2 แบบได้แก่ push และ reply

#### **Push messages**
![LINE Messaging API](images/3.1.png)

การส่งข้อความจาก Chatbot ไปหาผู้ใช้ โดยที่ผู้ใช้อยู่เฉยๆไม่ได้มีการ request อะไรมาที่ Chatbot (ลักษณะ One-way communication) เช่น Chatbot ส่งข้อความโปรโมชั่นไปหาผู้ใช้

#### **Reply messages**
![LINE Messaging API](images/3.2.png)

เป็นการโต้ตอบกับ Chatbot โดยผู้ใช้เป็นคน request มาที่ Chatbot ก่อนและตัว Chatbot ทำการตอบข้อความกลับไปหาผู้ใช้ เช่น ผู้ใช้ส่งข้อความเข้ามา หรือ ผู้ใช้ทำการ Add Chatbot เป็นเพื่อน (ผู้ใช้เป็นคนทักหา Account เราก่อน ลักษณะ Two-way communication)

### Webhook events คืออะไร?
**Webhook events** คือเหตุการณ์ event ต่างๆ ที่เกิดขึ้นกับ Chatbot ของเรา (event trigger) เมื่อผู้ใช้มีการโต้ตอบหรือใช้งาน LINE OA โดย event เกิดขึ้นจะมีสัญญาณพร้อมกับข้อมูลในรูปแบบที่เป็น JSON วิ่งมาที่ Webhook ที่เราผูกไว้กับ LINE OA  ซึ่งภายใน JSON นั้นจะมี replyToken ที่ไว้ใช้สำหรับการ Reply messages เพื่อตอบกลับผู้ใช้ได้นั่นเอง
   ![LINE Messaging API](images/3.3.png)

### การสร้าง Webhook Server ด้วย n8n
ในการพัฒนา Webhook Server เพื่อจะรอรับ events และทำการตอบกลับเพื่อสร้างเป็น LINE Chatbot นั้นสามารถทำได้หลายวิธี แต่ในบทความนี้จะใช้ n8n ในการเป็น Webhook Server 

#### ภาพรวมการทำงานเมื่อนำ n8n มาใช้เป็น Webhook Server
![Architecture](images/3.4.png)

**ขั้นตอนการทำงานตามภาพประกอบ:**

1. **LINE APP: ผู้ใช้งาน (User)**
   - เริ่มต้นการกระทำ เช่น ส่งข้อความ ส่งรูปภาพ หรือเพิ่มเพื่อน

2. **LINE Platform (LINE Bot Platform)**
   - ทำหน้าที่เป็นตัวกลาง จัดการการรับส่งข้อความ
   - เมื่อมีเหตุการณ์ (Event) เกิดขึ้น จะทำการส่ง Webhook (ข้อมูล JSON) ไปยัง URL ของ Server ที่เรากำหนดไว้
   - รอรับ API requests จาก Server ของเรา เพื่อส่งข้อความตอบกลับ (Response) ไปยังผู้ใช้

3. **Webhook Server (n8n)**
   - ทำหน้าที่รอรับ Webhook events ที่ส่งมาจาก LINE Platform
   - นำข้อมูลที่ได้มาประมวลผลตาม Workflow ที่เราออกแบบไว้ใน n8n
   - เมื่อประมวลผลเสร็จ และต้องการตอบกลับ จะทำการส่ง API call กลับไปยัง LINE Messaging API เพื่อให้ LINE ส่งข้อความไปหาผู้ใช้


## สร้าง LINE OA และเปิดใช้งาน Messaging API
Duration: 0:15:00

### สร้าง LINE Official Account

จุดเริ่มต้นของการพัฒนา LINE Chatbot คือคุณจะต้องสร้าง LINE OA(LINE Official Account) และเปิดใช้งาน Messaging API

1. เข้าไปที่ [https://manager.line.biz](https://manager.line.biz) แล้วเลือก **Log in with LINE account** (สีเขียว) เพื่อเข้าสู่ระบบ

![LINE Manager Login](images/4.1.png)

2. เข้าสู่ระบบด้วยบัญชี LINE ของคุณให้เรียบร้อย
3. กดสร้าง LINE OA จากปุ่ม **Create LINE official account** สำหรับผู้ที่สร้าง LINE OA ครั้งแรก หรือกด **Create new** ทางด้านซ้ายสำหรับผู้ที่เคยสร้าง LINE OA แล้ว
![LINE Manager Dashboard](images/4.2.png)
4. ให้ระบุข้อมูลต่างๆ ลงไปในฟอร์ม แล้วกด **ตกลง**
![Create LINE OA](images/4.3.png)
5. จากนั้นให้ยืนยันรายละเอียดในการสร้าง LINE OA เป็นอันเสร็จสิ้น
![LINE OA Form](images/4.4.png)



### เปิดใช้งาน Messaging API

หลังจากที่เรามี LINE OA เรียบร้อยแล้ว ขั้นตอนนี้จะพาทุกคนไปเพิ่มความสามารถให้ LINE OA ของเรากลายเป็น LINE Chatbot ได้

1. เข้าไปที่ [https://manager.line.biz](https://manager.line.biz) ในกรณีที่เรามีบัญชี LINE OA ที่สร้างไว้แล้ว หน้านี้จะแสดงบัญชี LINE OA ต่างๆ ที่เรามี ก็ให้เรากดเลือกบัญชี LINE OA ที่เราต้องการ

![Select LINE OA](images/4.5.png)

2. ให้เราไปที่เมนู **Settings > Messaging API** แล้วให้กดปุ่ม **Enable Messaging API**

![Enable Messaging API](images/4.6.png)

3. หากเป็นการ Enable Messaging API ครั้งแรกของบัญชี LINE Business ID จะเจอหน้าให้ลงทะเบียน Developer info ก็ให้กรอก **ชื่อ** และ **อีเมล**

![Developer Info](images/4.7.png)

4. จากนั้นให้สร้าง Provider ใหม่ หรือเลือก Provider เดิมกรณีที่เคยสร้างไปแล้ว

![Create Provider](images/4.8.png)

<aside class="positive">
<strong>Note:</strong> Provider คือชื่อผู้ให้บริการ ซึ่งจะไปแสดงตามหน้า consent ต่างๆ ซึ่งถือเป็น superset ของ chatbot ทั้งหลายที่เราจะพัฒนาขึ้นรวมถึง LIFF app โดยเราสามารถระบุชื่อของ Provider เป็น ชื่อตัวเอง, ชื่อบริษัท, ชื่อทีม หรือชื่อกลุ่มก็ได้
</aside>

<aside class="negative">
<strong>Remember:</strong> 1 Account สามารถมี Provider สูงสุดได้ 10 Providers และไม่สามารถมีคำว่า LINE ในชื่อ Provider ได้
</aside>

5. ระบุ URL ของ **Privacy Policy** และ **Terms of Use** (ถ้ามี) หากยังไม่มีก็สามารถกดปุ่ม **ตกลง** ข้ามไปได้

![Privacy Policy and Terms](images/4.9.png)

6. ยืนยันการเปิดใช้งาน Messaging API ด้วยการกด **Ok**

![Confirm Messaging API](images/4.10.png)

7. เมื่อเจอหน้านี้ ก็แปลว่าคุณได้เปิดใช้งาน Messaging API ให้กับบัญชี LINE OA เรียบร้อยแล้ว

![Messaging API Enabled](images/4.11.png)

### เพิ่ม Chatbot เป็นเพื่อนและตั้งค่า Channel

ขั้นตอนนี้เราจะเข้าไปใช้งาน LINE Developers Console ซึ่งเป็นเว็บไซต์สำหรับการบริหารจัดการ LINE Chatbot(LINE OA ที่เปิดใช้งาน Messaging API แล้ว) ในส่วนของนักพัฒนา

1. เข้าไปที่ [https://developers.line.biz/console/](https://developers.line.biz/console/)
   ให้กดเลือก **Provider** ที่ต้องการ

![Select Provider](images/4.12.png)

2. เราจะพบกับบัญชี LINE OA ที่เราได้เปิดใช้งาน Messaging API ไว้ ซึ่งในที่นี้เราจะเรียกมันว่า **Channel** (Channel จะเปรียบเสมือน Chatbot หรือ App) ก็ให้กดเลือก **Channel** ที่ต้องการ

![Select Channel](images/4.13.png)

3. ให้ไปที่ Tab ชื่อ **Messaging API** และทำการแสกน **QR code** ด้วยแอป LINE เพื่อเพิ่ม Chatbot เป็นเพื่อน

![Scan QR Code](images/4.14.png)

4. ให้ปิด **Auto-reply messages** เนื่องจากฟีเจอร์นี้จะเป็น default การตอบกลับของ Chatbot ซึ่งไม่จำเป็นต้องใช้ฟีเจอร์นี้

![Disable Auto-reply](images/4.15.png)
![Disable Auto-reply](images/4.16.png)

5. กลับมาที่ Channel ที่เราสร้างใน Tab ชื่อ **Messaging API** ตรงส่วนของ **Channel access token** ให้กดปุ่ม **Issue**

![Issue Channel Access Token](images/4.17.png)

<aside class="negative">
<strong>Important:</strong> ตัว Channel Access Token คือกุญแจสำคัญในการใช้งาน Messaging API ดังนั้นให้เก็บรักษาไว้ให้ดี
</aside>


## ทำความรู้จักกับ n8n
Duration: 0:10:00

### n8n คืออะไร?
**[n8n](https://n8n.io/)** (pronounced "n-eight-n") เป็น open-source workflow automation tool ที่ช่วยให้คุณสามารถเชื่อมต่อ services และ APIs ต่างๆ เข้าด้วยกันได้โดยไม่ต้องเขียนโค้ดมาก
![n8n](images/n8n-page.png)
#### ฟีเจอร์หลัก

- **Visual Workflow Editor**: สร้าง workflow ด้วยการ drag-and-drop
- **400+ Integrations**: เชื่อมต่อกับ services มากมาย (Google, Slack, GitHub, Database, APIs)
- **Self-hosted**: สามารถ host เองได้ (ฟรี) หรือใช้ n8n Cloud (paid)
- **Extensible**: เขียน custom nodes ได้ด้วย JavaScript/TypeScript
- **Workflow Templates**: มี templates สำเร็จรูปให้ใช้


### เหมาะกับงานแบบไหน?


1. **Automation Tasks** - จัดการข้อมูลระหว่าง services, สร้าง reports อัตโนมัติ, Sync ข้อมูลระหว่าง systems
2. **API Integration** - เชื่อมต่อ APIs หลายตัวเข้าด้วยกัน, Transform และ enrich ข้อมูล, สร้าง API endpoints ใหม่
3. **Chatbots & AI Agents** - สร้าง chatbot สำหรับ messaging platforms, เชื่อมต่อกับ AI/LLM services, จัดการ conversation flow
4. **Data Processing** - Process และ transform ข้อมูล, ส่งข้อมูลไปยัง database, สร้าง data pipelines
5. **Notifications & Alerts** - ส่งการแจ้งเตือนเมื่อมี event เกิดขึ้น, สร้าง monitoring workflows, Integrate กับ notification services

### แนวคิด Workflow-based Automation

#### Workflow คืออะไร?

**Workflow** คือลำดับของ steps (nodes) ที่ทำงานต่อเนื่องกัน โดยแต่ละ node จะ:
- รับข้อมูลจาก node ก่อนหน้า
- ประมวลผลข้อมูล
- ส่งข้อมูลไปยัง node ถัดไป

#### ตัวอย่าง Workflow
![Workflow](images/n8n-example-workflow.png)

#### ประเภทของ Nodes
![Nodes](images/n8n-node-types.png)
1. **Trigger Nodes**: เริ่ม workflow (Webhook, Schedule, Manual Trigger)
2. **Action Nodes**: ทำ action ต่างๆ (HTTP Request, Database, Email)
3. **Logic Nodes**: ควบคุม flow (IF, Switch, Merge)
4. **Data Nodes**: จัดการข้อมูล (Set, Code, Function)
5. **AI Nodes**: เชื่อมต่อกับ AI services (Gemini, OpenAI, Anthropic)

#### ข้อดีของ Workflow-based

- **Visual**: เห็น flow ทั้งหมดได้ชัดเจน
- **No Code / Low Code**: ไม่ต้องเขียนโค้ดมาก
- **Reusable**: สามารถ reuse workflows และ nodes
- **Debuggable**: ดูข้อมูลในแต่ละ step ได้ง่าย


#### สรุป: ทำไมเลือก n8n?

1. **Self-hosted ฟรี**: ไม่มีค่าใช้จ่ายสำหรับ self-hosted
2. **Open Source**: สามารถปรับแต่งและ extend ได้
3. **Flexibility**: เชื่อมต่อกับ services มากมาย
4. **Control**: ควบคุมข้อมูลและ infrastructure ได้เต็มที่
5. **Cost-effective**: ประหยัดเมื่อเทียบกับ SaaS solutions



## ใช้งาน n8n แบบ Self-host บน Render
Duration: 0:20:00
โดยทั่วไปคุณสามารถเลือกใช้ n8n ได้สองรูปแบบ คือ n8n Cloud หรือ n8n Self-hosted ซึ่งแบบ Self-hosted นั้นใช้งานได้ฟรี ใน Codelab นี้ เราจะดำเนินการ deploy n8n บน Render ด้วยการใช้ Docker image ที่มีอยู่แล้ว

![Architecture](images/architecture.png)
### ขั้นตอนทั้งหมด

1. เข้าสู่ระบบ Render Dashboard
2. สร้าง Web Service บน Render
3. ตั้งชื่อ Service และเลือก Plan
4. ตั้งค่า Environment Variables และ Deploy
5. เริ่มต้นใช้งาน n8n บน Render

---

### 1. เข้าสู่ระบบ Render Dashboard

* ไปที่ [Render Register](https://dashboard.render.com/register)
* ในหน้าการเข้าสู่ระบบ **Create an account** 
   * เลือกเข้าสู่ระบบด้วย **Google** เพื่อใช้งาน​ Render ด้วยบัญชี Google ของคุณ
   * Choose an account: เลือกบัญชี Google ที่จะใช้งาน

* เมื่อเข้าสู่ระบบสำเร็จ ระบบจะพาคุณไปยังหน้า Render Dashboard
   ![Render Dashboard - Login](images/5.1.png)
   ![Render Dashboard - Login](images/5.2.png)

### 2. สร้าง Web Service บน Render

* ที่หน้า Render Dashboard ให้ดูที่หัวข้อ **Web Services** 
   * คลิกปุ่ม **"New Web Service"** (หรือคลิก **"New +"** ที่มุมขวาบนแล้วเลือก **Web Service**)
   ![Render Dashboard - New Web Service](images/5.4.png)

* ในหน้าถัดมา หัวข้อ **Source Code**:
   * เลือกแท็บ **"Existing Image"**
   * ในช่อง **Image URL** ใส่: `n8nio/n8n:latest`
   * คลิกปุ่ม **"Connect"**
   ![Render Dashboard - New Web Service](images/5.5.png)

### 3. ตั้งชื่อ Service และเลือก Plan

* **Name**: ตั้งชื่อ Service ของคุณ 
   * เช่น Name: `YOURNAME-n8n-server-yyyy`
* **Region**: เลือกภูมิภาคของเซิร์ฟเวอร์ที่ใกล้ที่สุดเพื่อความเร็วในการเชื่อมต่อ
   * แนะนำ `Singapore  (Southeast Asia)`
* **Instance Type**:
   * เลือก **Free** สำหรับการทดสอบ
* เลื่อนลงมาด้านล่างสุดของเพจ และกด ** Deploy

![Render Dashboard - New Web Service](images/5.6.png)
![Render Dashboard - New Web Service](images/5.7.png)

### 4. ตั้งค่า Environment Variables และ Deploy 

* คลิกเลือกเมนู **"Environment"** เพื่อทำการตั้งค่าตัวแปรสำคัญในการใช้งาน Webhook และคลิก **"Add Environment Variable"**
* เพิ่ม Environment Variables ตามตารางด้านล่าง:


   | **Key** | **Value** | **Description** |
   |---------|-----------|-----------------|
   | `N8N_PROTOCOL` | `https` | Protocol สำหรับ webhook |
   | `WEBHOOK_URL` | `https://[ชื่อแอปของคุณ].onrender.com/` | Webhook URL สำหรับ n8n เช่น `https://beat-server-2026.onrender.com/` |


* กด **Save and Deploy**
   ![Render Dashboard - New Web Service](images/5.8.png)

* หลังจากนั้นให้คลิกไปยังเมนู **Events** และรอจนกว่า Deployment จะเสร็จสมบูรณ์ (ประมาณ 2-5 นาที)
   ![Render Dashboard - New Web Service](images/5.9.png)



### 5. เริ่มต้นใช้งาน n8n บน Render
หลังจาก Deploy เสร็จ ให้เปิด URL ด้านบนซ้ายเพื่อเริ่มต้นใช้งาน n8n คุณจะพบหน้า n8n Register ที่ให้กรอกข้อมูลสำหรับสร้าง account n8n

<aside class="negative">
<strong>⚠️ Important:</strong> Instance Type แบบฟรีจะหยุดทำงานเมื่อไม่มีการใช้งาน และจะทำให้การเรียกใช้งานครั้งแรกล่าช้า 50 วินาทีหรือมากกว่า
</aside>

<aside class="negative">
<strong>⚠️ Important:</strong> Render Free plan ไม่มี persistent storage ซึ่งหมายความว่า **workflow ที่คุณสร้างไว้จะไม่ถูกบันทึก** เมื่อ server ถูก sleep หรือ restart เนื่องจากไม่มี persistent memory ดังนั้นควรพิจารณา upgrade เป็นแผน Starter หรือสูงกว่าเพื่อให้ workflow ถูกบันทึกถาวร Instance Type แบบฟรีจะหยุดทำงานเมื่อไม่มีการใช้งานติดต่อกันเป็นเวลา 15 นาที
</aside>

* เข้าสู่ n8n หลังจาก Deploy เสร็จสมบูรณ์
   ![n8n Setup Owner Account](images/5.9.2.png)
* ตั้งค่าบัญชีผู้ดูแลระบบ (Owner Account)
   เมื่อเปิด URL ขึ้นมาครั้งแรก จะปรากฏหน้า **Set up owner account** ให้กรอกข้อมูลเพื่อสร้างบัญชี Admin:
   - **Email**: อีเมลของคุณ
   - **First Name / Last Name**: ชื่อและนามสกุล
   - **Password**: ตั้งรหัสผ่าน (ต้องมีอย่างน้อย 8 ตัวอักษร, ตัวเลข, และตัวพิมพ์ใหญ่)
   - คลิกปุ่ม **"Next"**

<aside class="positive">
<strong>Tip: </strong> เนื่องจาก n8n server นี้เป็น Self-hosted ที่เราใช้เพียงคนเดียว เราไม่จำเป็นต้องใส่ข้อมูลจริงๆ ก็ได้
</aside>

   ![n8n Setup Owner Account](images/5.10.png)

* ระบบจะสอบถามข้อมูลการใช้งานเบื้องต้น (เช่น บทบาทของคุณ, ขนาดบริษัท) โดยในส่วนนี้ให้คุณข้ามไปได้เลย
   * คลิกปุ่ม **Get started**
   * คลิกปุ่ม **Skip**
   ![n8n Customize](images/5.11.png)

* เมื่อเข้าสู่หน้า Dashboard หลัก จะพบข้อความต้อนรับ **Welcome [ชื่อของคุณ]!**  และหน้า canvas ที่พร้อมสำหรับเริ่มงาน
![n8n Customize](images/5.12.png)

## สร้าง LINE Webhook Node บน n8n และเชื่อมต่อกับ LINE Chatbot
Duration: 0:15:00

เราจะตั้งค่า n8n ให้รับข้อความจาก LINE โดยใช้ Node **"Line Messaging"** (ต้องติดตั้งเพิ่ม) ซึ่งจะจัดการเรื่อง Webhook ให้เราโดยอัตโนมัติ 

### ขั้นตอนทั้งหมด
1. สร้าง Workflow ใหม่
2. ติดตั้งและเพิ่ม Node LINE Messaging
3. ตั้งค่าการเชื่อมต่อ (Credentials)
4. เพิ่ม Reply Node
5. ตั้งค่า Webhook URL ใน LINE Developer Console
6. ทดสอบผ่าน LINE บนมือถือ
7. ตรวจสอบการทำงานของ Workflow บน n8n

---

### 1. สร้าง Workflow ใหม่
เมื่อเข้าสู่หน้า Dashboard คลิกที่การ์ด **"Start from scratch"**
   ![n8n Welcome](images/6.1.png)


### 2. ติดตั้งและเพิ่ม Node LINE Messaging
เนื่องจาก Node ของ LINE ไม่ได้มีติดมากับตัวตั้งต้น เราต้องทำการติดตั้งผ่าน Verified Community Nodes ก่อน

* คลิกปุ่ม **"+"** (Add first step) หรือปุ่มบวกมุมขวาบน
   ![n8n Add Node](images/6.2.png)
* ในช่องค้นหา พิมพ์ว่า `Line Messaging`
   ![n8n Search Line](images/6.3.png)
* คุณจะเห็น "Line Messaging" ให้คลิกเลือก จะปรากฏหน้าต่างรายละเอียด Node 
   * ให้กดปุ่ม **"Install node"**
   ![n8n Install Node](images/6.4.png)
* เมื่อติดตั้งเสร็จ ในส่วนของ Triggers 
   * เลือก **On all** ซึ่งจะเป็นการทำงานเมื่อได้รับ events ต่างๆ จาก LINE webhook
   ![n8n Install Node](images/6.5.png)

### 3. ตั้งค่าการเชื่อมต่อ (Credentials)

* ที่ช่อง **Credential to connect with** ให้เลือก **"Create new credential"**
   ![n8n Fill Credential](images/6.6.png)
* นำข้อมูลจาก LINE Developers Console มากรอก:
   * **Channel Access Token**
   * **Channel Secret**
   * เมื่อกรอกครบกด **Save** และ ปิดเพื่อที่จะทำการเพิ่ม node ถัดไปในการตอบกลับ
   ![n8n Fill Credential](images/6.7.png)
   ![n8n Fill Credential](images/6.8.png)
   ![n8n Fill Credential](images/6.9.png)
   ![n8n Fill Credential](images/6.10.2.png)

### 4. เพิ่ม Reply Node

* จาก Node `LINE Messaging Trigger` 
   * กด **+** เพื่อเพิ่ม Node ใหม่ที่เป็นการตอบกลับข้อความจาก LINE
   * โดยให้ทำการค้นหา `LINE Messaging`
   * ในส่วนของ LINE Messaging เลือก **"Reply to a message using a reply token"**
   ![n8n Fill Credential](images/6.11.png)
   ![n8n Fill Credential](images/6.12.png)
* ตั้งค่า **Reply Token** และ **Text**
   - ในช่อง Reply Token ให้ใส่ค่า:
      - `{{ $("Line Messaging Trigger").item.json.replyToken }}`
   - ในส่วนของการตอบกลับจะต้องทำการเพิ่มข้อความอัตโนมัติในการตอบ
      - กดปุ่ม **"Add Message"** 
      - แล้วพิมพ์ข้อความ `Hello from n8n` ในช่อง Text
   ![n8n Fill Credential](images/6.13.png)
   ![n8n Fill Credential](images/6.13.1.png)
   

### 5. ตั้งค่า Webhook URL ใน LINE Developer Console
* คลิกที่ Node `LINE Messaging Trigger` ให้ทำการดับเบิ่ลคลิกเพื่อดูรายเอียด
   - ไปเปิดแทป **Webhook URLs** 
   - คลิกเลือก **"Production URL"**
   - คลิกที่ Webhook URL เพื่อคัดลอก (จะเป็น `https://[ชื่อแอป].onrender.com/webhook/...`)
   ![n8n Fill Credential](images/6.15.png)
   ![n8n Fill Credential](images/6.16.png)

* กดปุ่ม **Save** มุมขวาบนแล้วจากนั้นกด **Publish** เพื่อให้ n8n สามารถทำงานเป็น Webhook Server ได้
    ![n8n Save Workflow](images/6.17-1.png)
    ![n8n Publish Workflow](images/6.17-2.png)
   <aside class="positive">
    <strong>สำคัญ:</strong> ต้องกด <strong>Publish</strong> ให้สถานะเป็นสีเขียว เพื่อให้ Bot ทำงานได้จริงเมื่อเชื่อมต่อ
   </aside>
   
   ![n8n Publish Workflow](images/6.17-3.png)
   
* นำ Webhook URL ที่คัดลอกไว้ ไปวางในช่อง **Webhook settings** ที่หน้า LINE Developers Console 
   * **Edit** 
   * อย่าลืมเปิดสวิตช์ **Use webhook**
   * กด **Verify**
   ![n8n Verify Webhook](images/6.18.png)
* เมื่อ Verify ผ่าน จะขึ้น Success หมายความว่า webhook server n8n เชื่อมต่อกับ LINE แล้วพร้อมรับทุก events ที่ส่งมาที่ LINE OA ของเรา
    ![n8n Use Webhook](images/6.19.png)

### 6. ทดสอบผ่าน LINE บนมือถือ
จะเห็นได้ว่า n8n workflow นี้สามารถตอบกลับเป็นข้อความอัตโนมัติได้

![n8n Test Chat](images/6.20.png)

### 7. ตรวจสอบการทำงานของ Workflow บน n8n
ในส่วนด้านบนของ n8n interface คุณสามารถกดเลือก **Execution** เพื่อดูการทำงานของ n8n ที่ใช้เป็น Webhook server รับ events จาก LINE ได้ โดยจะแสดงรายละเอียดการทำงานของแต่ละ node และข้อมูลที่ผ่านเข้ามา

<aside class="positive">
<strong>Tip:</strong> ใช้ n8n Execution Log เพื่อ debug และดูข้อมูลที่ผ่านแต่ละ node
</aside>

![n8n Test Chat](images/6.21.png)


## ทำความรู้จัก AI Agent
Duration: 0:15:00

**AI Agent** คือระบบบอทที่มีความสามารถสูงกว่า Chatbot ทั่วไป โดยใช้เทคโนโลยี Generative AI และ LLM (Large Language Model) เป็นแกนหลักในการประมวลผล ทำให้มีความสามารถในการทำความเข้าใจภาษาและบริบทที่ซับซ้อน ได้แก่:
- **เข้าใจความหมาย (Understand Meaning):** สามารถตีความเจตนาของผู้ใช้งานได้ และตอบกลับตามโจทย์ธุรกิจ
- **ตอบตามบริบท (Context Aware):** สามารถจดจำและเชื่อมโยงข้อมูลจากการสนทนาก่อนหน้า ทำให้การโต้ตอบมีความต่อเนื่อง
![n8n Test Chat](images/7.1.1.png)
### องค์ประกอบหลักของ AI Agent

โครงสร้างการทำงานของ AI Agent ประกอบด้วย 5 ส่วนสำคัญ คือ:
1. **User Message** คำถามที่ผู้ใช้ต้องการถามหรือสนทนากับ Agent
2. **LLM Model:** โมเดลภาษาที่เป็นหน่วยประมวลผลหลักและคลังความรู้
3. **System Prompt:** คำสั่งกำกับดูแลเพื่อกำหนดพฤติกรรมของ Agent
4. **Memory:** หน่วยความจำสำหรับเก็บประวัติการสนทนา เข้าใจความต่อเนื่องของบทสนทนา
5. **Tools:** เครื่องมือสำหรับเชื่อมต่อกับระบบภายนอกเพื่อทำภารกิจต่างๆ

---

### เจาะลึก System Prompt
**System Prompt** (หรือ Instruction Prompt) คือส่วนประกอบที่สำคัญที่สุดในการกำหนดบุคลิกและการทำงานของ AI Agent เปรียบเสมือนชุดคำสั่งที่ระบุขอบเขตความรับผิดชอบ เพื่อให้ LLM ทำงานได้ตรงตามวัตถุประสงค์

การเขียน Instruction ที่ดีสำหรับ AI Agent ควรกำหนดหัวข้อต่อไปนี้ให้ชัดเจน:
* **Persona:** กำหนดบทบาทว่า Agent คือใคร (เช่น เจ้าหน้าที่ Support, ผู้เชี่ยวชาญเฉพาะด้าน)
* **Objective:** ระบุเป้าหมายหลักของการทำงาน (เช่น การตอบคำถาม, การปิดการขาย)
* **Context:** ระบุข้อมูลบริบทที่ Agent ต้องรู้ (เช่น ข้อมูลสินค้า, เมนูอาหาร, นโยบายบริษัท)
* **Constraints:** กำหนดข้อจำกัดหรือสิ่งที่ห้ามทำ (เช่น ห้ามตอบนอกเหนือข้อมูลที่มี, ห้ามใช้ภาษาที่ไม่สุภาพ)
![n8n Test Chat](images/7.2.png)


### การเรียกใช้เครื่องมือ (Tool Calling) 

![AI Agent](images/7.3.png)
**Tool Calling**  คือความสามารถของ AI ในการเลือกใช้เครื่องมือหรือฟังก์ชันเพื่อกระทำสิ่งต่างๆ นอกเหนือจากการคุยตอบโต้ปกติ เช่น:
* **ค้นหาข้อมูล:** เรียก API เพื่อดึงข้อมูล Real-time
* **คำนวณ:** ใช้ฟังก์ชันทางคณิตศาสตร์หรือตรรกะที่ซับซ้อน
* **บันทึกข้อมูล:** เชื่อมต่อ Database เพื่อบันทึกสถานะ
* **เชื่อมต่อกับบริการภายนอก:** เชื่อมต่อกับบริการภายนอกอื่น เช่น ส่ง LINE Flex Message ผ่าน LINE Messaging API

### ตัวอย่าง Use Case ของ AI Agent

การกำหนด Instruction ที่แตกต่างกัน จะทำให้ได้ AI Agent ที่มีหน้าที่แตกต่างกันอย่างสิ้นเชิง ดังตัวอย่างต่อไปนี้:
![AI Agent](images/7.4.png)
1. Customer Service Agent
   * **Instruction:** กำหนดบทบาทเป็นเจ้าหน้าที่บริการลูกค้า ให้ข้อมูลด้วยความสุภาพและถูกต้องตามนโยบาย
   * **การทำงาน:** ตอบคำถามเกี่ยวกับสินค้า แก้ไขปัญหาเบื้องต้น และให้คำแนะนำการใช้งาน

2. E-commerce Shopping Assistant
   * **Instruction:** กำหนดบทบาทเป็นผู้ช่วยช้อปปิ้ง แนะนำสินค้าโดยวิเคราะห์จากความต้องการของผู้ใช้
   * **การทำงาน:** สอบถามสไตล์ที่ชอบ แนะนำสินค้าที่เกี่ยวข้อง และช่วยเปรียบเทียบคุณสมบัติ

3. Appointment Booking Agent
   * **Instruction:** กำหนดบทบาทเป็นเจ้าหน้าที่รับจองคิว ตรวจสอบตารางเวลาว่างและยืนยันนัดหมาย
   * **การทำงาน:** รับเรื่องการจอง ตรวจสอบ Slot เวลาว่างจากระบบ และบันทึกการนัดหมาย

## ทำความรู้จัก AI Studio และ Gemini
![AI Agent](images/x.0.png)
**Google AI Studio** เป็นแพลตฟอร์มที่ Google จัดทำขึ้นเพื่อให้ผู้พัฒนาสามารถทดสอบและใช้งาน Google Gemini AI models ได้อย่างง่ายดาย โดยสามารถสร้าง API Key เพื่อใช้เชื่อมต่อกับ Gemini models ผ่าน API ได้

**Google Gemini** เป็น Large Language Model (LLM) ที่พัฒนาโดย Google ที่มีความสามารถในการประมวลผลภาษาและสร้างข้อความตอบกลับที่มีความหมายและเป็นธรรมชาติ

### ขั้นตอนการสร้าง Gemini API Key

1. **สร้าง Project**
   * ไปที่ [Google AI Studio](https://aistudio.google.com/)
   * เข้าสู่ระบบด้วยบัญชี Google ของคุณ
   * สร้าง Project ใหม่หรือเลือก Project ที่มีอยู่แล้ว
   ![AI Agent](images/x.1.png)
   ![AI Agent](images/x.2.png)
   ![AI Agent](images/x.3.1.png)

2. **สร้าง Gemini API Key**
   * คลิกที่เมนู **Get API Key** หรือไปที่ [API Keys](https://aistudio.google.com/app/apikey)
   * คลิกปุ่ม **Create API Key**
   * เลือก Project ที่ต้องการใช้
   * คัดลอก API Key ที่สร้างขึ้นมา (เก็บไว้ใช้ในขั้นตอนถัดไป)
   ![AI Agent](images/x.3.png)
   ![AI Agent](images/x.4.png)
   ![Google AI Studio](images/8.9.png)


<aside class="negative">
<strong>⚠️ Important:</strong> API Key เป็นข้อมูลสำคัญที่ใช้ในการเข้าถึง Gemini API ควรเก็บรักษาให้ปลอดภัยและไม่เปิดเผยให้ผู้อื่นทราบ
</aside>

## สร้าง AI Agent Node บน n8n

ขั้นตอนการเพิ่มสมองให้บอทด้วยการใช้ AI Agent Node เพื่อประมวลผลข้อความจาก LINE และตอบกลับด้วย Google Gemini

### ขั้นตอนทั้งหมด
1. เพิ่ม AI Agent Node
2. ตั้งค่า Prompt (User Message) ในการรับข้อความจากผู้ใช้งาน LINE OA
3. เชื่อมต่อ Chat Model
4. ตั้งค่า Google Gemini API Key และเลือกโมเดล

---

### 1. เพิ่ม AI Agent Node
* ในหน้า Workflow ให้กดปุ่ม **"+"** ระหว่างที่เส้นเชื่อม Node 'Line Messaging Trigger' เพื่อแทรก Node ใหม่
   * เลือกเมนู **AI**
   * เลือก **AI Agent**

![Insert Node](images/8.1.png)
![Select AI Category](images/8.2.png)
![Select AI Agent](images/8.3.png)

### 2. ตั้งค่า Prompt (User Message) ในการรับข้อความจากผู้ใช้งาน LINE OA
กำหนดให้ AI รับข้อความที่ผู้ใช้พิมพ์เข้ามาผ่าน LINE มาประมวลผลต่อและคิดคำตอบที่ควรตอบตามที่เราจะระบุในคำสั่งการทำงานของ AI
* ที่ช่อง **Source for Prompt (User Message)** 
   * เลือกเป็น `Define below`
* ที่ช่อง **Prompt (User Message)** ให้ใส่ Expression เพื่อดึงข้อความจาก LINE:
   * Prompt (User Message): `{{ $("Line Messaging Trigger").item.json.message.text }}`

   ![Set Define Below](images/8.4.png)
   ![Input Expression](images/8.5.png)

* ในส่วนของ **Add Option** ให้เราทำการกดเพิ่ม 
   * เลือก **System message** เพื่อเป็นการเพิ่มคำสั่งการทำงาน
   *  จะเห็นว่า System message พื้นฐานนั้นคือ `You are a helpful assistant` ซึ่งเราสามารถแก้ไขได้ในขั้นตอนถัดไป
   ![System message](images/8.6.png)
   ![System message](images/8.6.1.png)

### 3. เชื่อมต่อ Chat Model
เพิ่มโมเดลภาษา (LLM) ให้กับ Agent เพื่อใช้ในการประมวลผลคำตอบ
* กดปุ่ม **"+"** ที่ช่อง `Chat Model` ด้านล่างของ Node `AI Agent`
* ค้นหาและเลือก `Google Gemini Chat Model`

![Select Gemini Model](images/8.7.png)

### 4. ตั้งค่า Google Gemini API Key และเลือกโมเดล
การเชื่อมต่อกับ Google Gemini จำเป็นต้องใช้ API Key

* ใน node `Google Gemini Chat Model` ส่วนของ **Credential to connect with** 
   * เลือก **Create new credential**
   * นำ Gemini API Key ที่คัดลอกมา วางลงในช่อง **API Key** 
   * กด **Save**
   ![Create Credential](images/8.8.png)
   ![Paste API Key](images/8.10.png)

* ที่ช่อง **Model** ให้เลือกโมเดลที่จะเป็นตัวประมวลผลของ AI Agent
* โมเดลที่สามารถเลือกได้มีดังนี้ 
   * `models/gemini-2.5-flash` 
   * `models/gemini-2.5-flash-lite` 
   * `models/gemini-3-flash-preview`
* ในส่วนของ Options ให้ตั้งค่า **Max output token** เป็น 500

   ![Select Gemini Model Version](images/8.11.png)
   
   <aside class="negative">
   <strong>Importance:</strong> การตั้งค่า Max output token เป็น 500 เพื่อป้องกันไม่ให้คำตอบยาวเกินไป เนื่องจาก LINE text response มี max character 5,000 ตัวอักษร
   </aside>

   <aside class="negative">
   <strong>⚠️ Quota ของ Gemini Model:</strong> Gemini model แต่ละตัวมี quota จำกัด โดยแต่ละ model ต่อ project เรียกได้แค่ **20 ครั้งต่อวัน ต่อ model (RPD)**  หาก quota เต็มจะทำให้ bot ไม่ตอบ วิธีแก้ให้เปลี่ยน model  ซึ่งสามารถตรวจสอบ quota ที่ <a href="https://aistudio.google.com/usage?timeRange=last-28-days&tab=rate-limit">Gemini Usage</a>
   </aside>

   ![Select Gemini Model Version](images/8.12.1.png)
   

## ตั้งค่า Memory เพื่อให้ AI จำบริบทในการสนทนาได้

**Simple Memory** คือระบบหน่วยความจำที่ช่วยให้ AI Agent สามารถจดจำและเข้าใจบริบทจากการสนทนาก่อนหน้าได้ โดยจะเก็บประวัติการสนทนาของแต่ละผู้ใช้แยกกันตาม Session ID ทำให้การตอบกลับมีความต่อเนื่องและเป็นธรรมชาติมากขึ้น

### ขั้นตอนทั้งหมด

1. เพิ่ม Simple Memory Node
2. ตั้งค่า Session ID
3. ส่งคำตอบที่ได้จาก AI Agent กลับไปยังผู้ใช้
4. Save และ Publish workflow และทำการทดสอบ
---

### 1. เพิ่ม Simple Memory Node

* ด้านล่างของ node `AI Agent` จะมีส่วน ให้เพิ่ม Memory เพื่อให้ Agent สามารถจดจำบริบทของการสนทนาได้
   * กดปุ่ม **"+"** ที่ช่อง **Memory** 
   * เลือก **Simple Memory**
   ![Select Simple Memory](images/8.12.png)

### 2. ตั้งค่า Session ID
ใน Codelabs นี้ Session ID คือ LINE UserId ที่ใช้เพื่อแยกประวัติการสนทนาของแต่ละผู้ใช้

* ที่ช่อง **Session ID** เลือก `Define below`

* ใส่ Expression เพื่อระบุตัวตนผู้ใช้ (User ID):
   - Key: `{{ $("Line Messaging Trigger").item.json.source.userId }}`
* ตั้งค่า **Context Window Length** (จำนวนข้อความที่ต้องการจำ) ตามต้องการ ในตัวอย่างคือ 5
   ![Set Session ID Define Below](images/8.13.png)
   ![Input Session ID Expression](images/8.14.png)

<aside class="positive">
<strong>Note:</strong> Session ID จะใช้เพื่อแยกประวัติการสนทนาของแต่ละผู้ใช้ โดยใช้ User ID จาก LINE เพื่อให้แต่ละคนมีประวัติการสนทนาที่แยกกัน
</aside>


<aside class="positive">
<strong>Tip:</strong> Context Window Length กำหนดจำนวนข้อความล่าสุดที่ AI จะจำได้ ยิ่งมากยิ่งจำได้นาน แต่จะใช้ token มากขึ้น
</aside>


### 3. ส่งคำตอบที่ได้จาก AI Agent กลับไปยังผู้ใช้

หลังจากที่ AI Agent ประมวลผลและสร้างคำตอบแล้ว เราต้องเชื่อมต่อกับ LINE Messaging Reply Node เพื่อส่งคำตอบกลับไปยังผู้ใช้
จาก node Reply ที่มีอยู่แล้วเราจะเข้าไปทำการแก้ไขข้อความตอบกลับ
โดย ตั้งค่า **Text** จะใส่ Expression เพื่อดึงคำตอบจาก AI Agent:
     `{{ $("AI Agent").item.json.output }}`

![Completed Workflow](images/8.15.png)
![Completed Workflow](images/8.15.1.png)

### 4. Save และ Publish workflow และทำการทดสอบ

เมื่อตั้งค่าครบแล้ว พร้อมสำหรับการทดสอบ อย่าลืมกด Save และ Publish
![Completed Workflow](images/8.15.2.png)

จากการทดสอบจะพบว่า Chatbot ที่ได้ตอบแบบข้อความอัตโนมัติได้เปลี่ยนเป็นตอบด้วย AI แล้ว แต่ยังไม่ตอบตรงโจทย์ธุรกิจที่เราสามารถเอาไปต่อยอดได้ ซึ่งเราจะไปทำการพัฒนาในหัวข้อถัดไป

![Completed Workflow](images/8.16.png)



## เพิ่ม Agents Tools ในการส่ง LINE Flex Message
Duration: 0:10:00

ในส่วนนี้คุณจะได้เรียนรู้เกี่ยวกับ LINE Flex Message และ LINE Flex message simulator เพื่อออกแบบข้อความสวยงามโดยไม่ต้องเขียนโค้ด จากนั้นจะได้เรียนรู้วิธีการ **สร้าง Node LINE Messaging Tool** และ ตั้งค่าให้ AI Agent สามารถส่ง LINE Flex Message ได้ และสุดท้ายจะได้ ทดสอบผลลัพธ์ใน LINE

### ขั้นตอนทั้งหมด

1. ทำความรู้จัก LINE Flex Message
2. สร้าง Node LINE Messaging Tool
3. ตั้งค่า LINE Flex Message JSON
4. แก้ไข System prompt ให้เรียกใช้งาน Tools
5. ทดสอบผลลัพธ์ใน LINE

---

### 1. ทำความรู้จัก LINE Flex Message
**LINE Flex Message** คือรูปแบบข้อความใน LINE ที่สามารถปรับแต่ง Layout ได้อย่างอิสระ (รูปภาพ, ปุ่ม, ข้อความ) ช่วยให้ Chatbot ดูเป็นมืออาชีพและน่าใช้งานมากขึ้น

ในการออกแบบ LINE Flex Message ให้ส่วยงามนั้น เราสามารถใช้ **Flex Message Simulator** ซึ่งเป็นเครื่องมือที่ช่วยออกแบบและสร้าง LINE Flex Message สามารถแสดงตัวอย่างและคัดลอกโค้ด JSON ไปใช้งานได้ทันที
![LINE Flex Message](images/9.1.png)

* เข้าไปที่ [LINE Flex Message Simulator](https://developers.line.biz/flex-simulator/) เพื่อดูตัวอย่าง Template
* เรียนรู้เพิ่มเติมได้ที่ [LINE Flex Message Codelab](https://codelab.line.me/codelabs/flex-message/index.html#1)

<aside class="negative">
<strong>Note:</strong> ใน Codelab นี้ เราจะใช้ LINE Flex Message ที่เตรียมไว้ด้านล่าง โดยไม่ได้ใช้ Template จาก Flex Message Simulator
</aside>


### 2. สร้าง Node LINE Messaging Tool

กลับมาที่ Workflow ใน n8n ของเรา เพื่อเชื่อมต่อเครื่องมือนี้เข้ากับ AI Agent ให้สามารถเรียกเครื่องมือเพื่อส่ง LINE Flex Message ได้ 

* ไปที่โหนด **AI Agent**
* คลิกที่เครื่องหมาย **`+`** ในส่วนของการเชื่อมต่อ **Tools** (Memory/Tool)
* ค้นหาคำว่า `LINE` และเลือก **"Line Messaging Tool"** (สังเกตคำอธิบาย: *Interact with the Line Messaging API*)

![Adding LINE Tool](images/9.2.png)

* ตั้งค่า Tool:
   - **Operation:** เลือก **Send**
   - **User ID:** ใส่ Expression เพื่อดึง User ID จาก LINE:
      - `{{ $("Line Messaging Trigger").item.json.source.userId }}`
   - **Messages:** กดปุ่ม **"Add Message"** 
      - เลือก **type: Flex Message**

![Adding LINE Tool](images/9.3.png)

### 3. ตั้งค่า LINE Flex Message JSON

* **Rename node:** ตั้งชื่อ node เป็น `Send LINE Flex Message` (เพื่อให้เข้าใจง่ายว่า node นี้ทำหน้าที่อะไร)
* **Alt Text:** ใส่ข้อความที่จะแสดงใน Notification เมื่อมีข้อความเข้า เช่น `เมนูอาหารแนะนำ`
* **LINE Flex Message JSON:** นำโค้ด JSON ที่เตรียมไว้ด้านล่างมาวางลงในช่องนี้

**LINE Flex Message JSON: ตัวอย่างโค้ด JSON สำหรับเมนูอาหาร:**
```json
{"type":"carousel","contents":[
{"type":"bubble","size":"micro","hero":{"type":"image","url":"https://images.unsplash.com/photo-1627308595186-e6bb36712645","size":"full","aspectMode":"cover","aspectRatio":"20:13","action":{"type":"uri","uri":"http://linecorp.com/"}},"body":{"type":"box","layout":"vertical","contents":[{"type":"text","text":"กะเพราหมูไข่ดาว","weight":"bold","size":"sm","wrap":true},{"type":"box","layout":"baseline","contents":[{"type":"icon","size":"xs","url":"https://scdn.line-apps.com/n/channel_devcenter/img/fx/review_gold_star_28.png"},{"type":"text","text":"4.8","size":"xs","color":"#999999","margin":"xs","flex":0},{"type":"text","text":"50.-","size":"sm","color":"#e03e3e","align":"end","weight":"bold","flex":1}]}],"spacing":"sm","paddingAll":"13px"},"footer":{"type":"box","layout":"vertical","contents":[{"type":"button","style":"primary","action":{"type":"message","label":"สั่งเลย","text":"สั่งกะเพราหมู"},"height":"sm","color":"#E34A32"}]}},
{"type":"bubble","size":"micro","hero":{"type":"image","url":"https://plus.unsplash.com/premium_photo-1661611585910-77ae42f0c71d","size":"full","aspectMode":"cover","aspectRatio":"20:13","action":{"type":"uri","uri":"http://linecorp.com/"}},"body":{"type":"box","layout":"vertical","contents":[{"type":"text","text":"ข้าวผัดกุ้ง","weight":"bold","size":"sm","wrap":true},{"type":"box","layout":"baseline","contents":[{"type":"icon","size":"xs","url":"https://scdn.line-apps.com/n/channel_devcenter/img/fx/review_gold_star_28.png"},{"type":"text","text":"4.5","size":"xs","color":"#999999","margin":"xs","flex":0},{"type":"text","text":"60.-","size":"sm","color":"#e03e3e","align":"end","weight":"bold","flex":1}]}],"spacing":"sm","paddingAll":"13px"},"footer":{"type":"box","layout":"vertical","contents":[{"type":"button","style":"primary","action":{"type":"message","label":"สั่งเลย","text":"สั่งข้าวผัดกุ้ง"},"height":"sm","color":"#E34A32"}]}},
{"type":"bubble","size":"micro","hero":{"type":"image","url":"https://images.unsplash.com/photo-1559314809-0d155014e29e?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80","size":"full","aspectMode":"cover","aspectRatio":"20:13","action":{"type":"uri","uri":"http://linecorp.com/"}},"body":{"type":"box","layout":"vertical","contents":[{"type":"text","text":"ผัดไทยกุ้งสด","weight":"bold","size":"sm","wrap":true},{"type":"box","layout":"baseline","contents":[{"type":"icon","size":"xs","url":"https://scdn.line-apps.com/n/channel_devcenter/img/fx/review_gold_star_28.png"},{"type":"text","text":"4.9","size":"xs","color":"#999999","margin":"xs","flex":0},{"type":"text","text":"80.-","size":"sm","color":"#e03e3e","align":"end","weight":"bold","flex":1}]}],"spacing":"sm","paddingAll":"13px"},"footer":{"type":"box","layout":"vertical","contents":[{"type":"button","style":"primary","action":{"type":"message","label":"สั่งเลย","text":"สั่งผัดไทย"},"height":"sm","color":"#E34A32"}]}}
]}
```

![Completed Workflow](images/9.4.png)

### 4. แก้ไข System prompt ให้เรียกใช้งาน Tools

เพื่อให้ AI Agent รู้ว่าควรเรียกใช้ Tool (Send LINE Flex Message) เมื่อไหร่ เราต้องเพิ่มคำสั่งใน System prompt

* ไปที่ node **Google Gemini Chat Model** (หรือ Model ที่คุณเลือกใช้)
* ในส่วนของ **System Instruction**  ให้เพิ่มคำสั่งเกี่ยวกับการใช้งาน Tool:

```
Trigger: ลูกค้าต้องการดูเมนู เช่น ขอเมนู, มีเมนูอะไรแนะนำ 
- Action: Tool: Send LINE Flex Message
```


<aside class="positive">
<strong>Note:</strong> การเพิ่มคำสั่งนี้จะทำให้ AI รู้ว่าควรเรียกใช้ Tool เมื่อผู้ใช้ถามเกี่ยวกับเมนูอาหาร ซึ่งจะทำให้สามารถส่ง LINE Flex Message ที่สวยงามได้
</aside>

![Completed Workflow](images/9.5.png)

### 5. ทดสอบผลลัพธ์ใน LINE
เมื่อตั้งค่าเสร็จเรียบร้อย ให้กด Save & Publish แล้วลองไปทดสอบคุยกับ Chatbot ใน LINE
![Completed Workflow](images/9.6.png)

ลองพิมพ์ประโยคที่กระตุ้นให้ AI ใช้เครื่องมือ เช่น "ขอเมนูอาหารหน่อย" หรือ "มีอะไรแนะนำบ้าง"

AI จะวิเคราะห์และเรียกใช้ Tool เพื่อส่ง LINE Flex Message ที่เราตั้งค่าไว้กลับมาอย่างสวยงาม ดังภาพ

![Completed Workflow](images/9.7.png)

## ปรับปรุง System Prompt ให้ Agent ตอบได้ตามโจทย์ธุรกิจ
Duration: 0:5:00

![n8n Test Chat](images/10.1.png)

เนื่องจากในก่อนหน้านี้ AI Chatbot ของเรายังเป็นเพียงโมเดลภาษาทั่วไป ซึ่งอาจตอบคำถามกว้างๆ และยังไม่ตรงกับบริบทของธุรกิจร้านอาหารของเรา เพื่อให้บอททำงานได้สมบูรณ์แบบ เราจึงจำเป็นต้องแก้ไข **System Prompt** หรือ **Instruction** เพื่อกำหนดบทบาท (Persona) และขอบเขตการทำงานให้ชัดเจน

### ขั้นตอนทั้งหมด
1. แก้ไข System Prompt โดยใช้ ตัวอย่าง Prompt สำหรับร้านอาหาร
2. ทดสอบผลลัพธ์ใน LINE

---

### 1. แก้ไข System Prompt โดยใช้ ตัวอย่าง Prompt สำหรับร้านอาหาร

ไปที่ node **Google Gemini Chat Model** ใน workflow ของคุณ
มองหาช่องที่เขียนว่า **System Message** เพื่อใส่คำสั่งที่ระบุตัวตนและหน้าที่ของ AI ลงไปให้ชัดเจน

**ตัวอย่าง Prompt สำหรับร้านอาหาร:**
```
# Instruction: น้องเอไอ – ผู้ช่วยร้านอาหารไทย

## 1. Persona & Tone
1.1 น้องเอไอเป็นผู้ช่วยแชตบอตสำหรับร้านอาหารไทย  
1.2 บุคลิก: สุภาพ อบอุ่น เป็นกันเอง 
1.3 สื่อสารด้วยน้ำเสียงใจดี ไม่เร่งรัด ไม่กดดันลูกค้า ตอบรับด้วยน้ำเสียงสุภาพและเป็นกันเอง  

## 2. Core Responsibilities
2.1 แนะนำเมนูอาหารไทยตามหมวดหมู่  
2.2 รับออร์เดอร์อาหาร (ทานที่ร้าน / สั่งกลับบ้าน)  
2.3 จัดการการจองโต๊ะล่วงหน้า  
2.4 ตอบคำถามเกี่ยวกับเวลาเปิด–ปิดร้าน: 9:00 - 18:00 
2.5 หากข้อมูลจากลูกค้าไม่ครบ ต้องถามต่ออย่างสุภาพเสมอ  

## 3. Food Menu 
Trigger: ลูกค้าต้องการดูเมนู เช่น ขอเมนู, มีเมนูอะไรแนะนำ 
- Action: แสดงเฉพาะหมวดที่ลูกค้าระบุ โดยดูข้อมูลจากข้อ 3. หากไม่มีให้แจ้งลูกค้า
- Mandatory Action: Call Tool: Send LINE Flex Message เพื่อแสดงเมนูแนะนำเสมอ

### 3.1 เมนูข้าวแกง
- ข้าวกระเพราไข่ดาว — 50 บาท  
- ข้าวผัดกุ้ง — 60 บาท  
- ผัดไทยกุ้งสด — 65 บาท  

### 3.2 เมนูตำ / ยำ
- ส้มตำไทย — 45 บาท  
- ส้มตำปูปลาร้า — 50 บาท  
- ลาบหมู — 65 บาท  

### 3.3 เครื่องดื่ม
- น้ำเก๊กฮวย — 20 บาท  
- น้ำลำไย — 20 บาท  
- น้ำเปล่า — 10 บาท  

## 5. Ordering Flow
5.1 เมื่อผู้ใช้แสดงความต้องการสั่งอาหาร  
น้องเอไอต้องถามตามลำดับ:
1) เมนูที่ต้องการ  
2) รูปแบบการรับอาหาร  
   - ทานที่ร้าน  
   - สั่งกลับบ้าน  
3) ชื่อผู้สั่ง  
4) เบอร์ติดต่อ  

5.2 ถ้าข้อมูลใดยังไม่ครบ  
- ถามเฉพาะข้อมูลที่ขาด  
- ห้ามถามซ้ำในสิ่งที่ลูกค้าให้มาแล้ว  

## 6. Constraints
6.1 ห้ามแต่งเมนูหรือราคาเพิ่มจากที่กำหนด  
6.2 ห้ามใช้ภาษาอังกฤษ  
6.3 ถ้าไม่มั่นใจข้อมูล ให้ถามลูกค้าแทนการเดา  

### 7. ตัวอย่างการตอบกลับ (Sample Dialogue)
ลูกค้า: "ร้านเปิดกี่โมง"
น้องเอไอ: "สวัสดีค่ะคุณลูกค้า ร้านเปิดให้บริการตั้งแต่ 9:00 ถึง 18:00 น. ค่ะ สนใจสั่งอาหารไว้ทานมื้อไหนดีคะ?"

ลูกค้า: "ขอเมนูหน่อย"
น้องเอไอ: "ได้เลยค่ะ นี่คือเมนูความอร่อยของทางร้านเรานะคะ" (Action: เรียกใช้ Tool: Send LINE Flex Message)
```

![n8n Test Chat](images/11.1.png)
![n8n Test Chat](images/11.2.png)


### 2. ทดสอบผลลัพธ์ใน LINE
กด **Save** และ **Publish** เพื่อบันทึก Workflow ก่อนทดสอบการทำงานของ Chatbot ใน LINE โดยลองถามคำถามต่างๆ เพื่อดูว่าบอทตอบตาม Instruction ที่เรากำหนดไว้หรือไม่

![n8n Test Chat](images/11.3.png)

ซึ่งจากผลลัพธ์จะเห็นว่าคุณสามารถสร้าง AI Chatbot บน LINE ที่สามารถตอบคำถามได้อย่างเป็นธรรมชาติ และส่ง LINE Flex Message ที่สวยงามได้แล้ว


## Congratulations
Duration: 0:05:00

ยินดีด้วยครับ ถึงตรงนี้คุณก็มี LINE AI Chatbot ตัวแรกเป็นของคุณเองแล้ว!!!

### ใน codelab นี้ คุณได้เรียนรู้:

✅ วิธีการ deploy n8n บน Render  
✅ วิธีการตั้งค่า LINE Messaging API  
✅ วิธีการสร้าง n8n workflow บน Render  
✅ วิธีการเชื่อมต่อกับ AI Model  
✅ วิธีการส่งคำตอบกลับไปยัง LINE  
✅ วิธีการเขียนคำสั่ง (Instruction Prompt) ให้ AI เข้าใจบริบทและตอบโจทย์ธุรกิจ

### ขั้นตอนถัดไป
- รองรับข้อความประเภทอื่น (ภาพ, ไฟล์, เสียง, สติกเกอร์)
- ปรับปรุง prompt engineering เพื่อให้ได้ผลลัพธ์ที่ดีขึ้น
- พิจารณา upgrade Render plan สำหรับ production

### เรียนรู้เพิ่มเติม

- [บทความเกี่ยวกับ LINE Chatbot](https://medium.com/linedevth/all?topic=chatbots)
- [Workflow n8n แบบสมบูรณ์ - ดาวน์โหลดเพื่อนำเข้าใน n8n](https://raw.githubusercontent.com/punsiriboo/my-codelabs/refs/heads/main/n8n-line-ai-agent/%5Bn8n-Workflow%5D%20Build%20a%20Smart%20AI%20Chatbot%20without%20Coding%20using%20n8n.json)
- [Exporting and importing workflows](https://docs.n8n.io/courses/level-one/chapter-6/)
<aside class="positive">
<strong>Tip:</strong> คุณสามารถดาวน์โหลด workflow file ด้านบนเพื่อนำเข้าใน n8n ได้โดยการคลิกที่ลิงก์ และใน n8n ให้ไปที่ **Workflows > Import from File** เพื่อนำเข้า workflow
</aside>


### Reference docs

- [LINE Messaging API Documentation](https://developers.line.biz/en/docs/messaging-api/)
- [LINE Flex Message](https://developers.line.biz/en/docs/messaging-api/using-flex-messages/)
- [n8n Documentation](https://docs.n8n.io/)
- [n8n Docker Hub](https://hub.docker.com/r/n8nio/n8n)
- [Render Documentation](https://render.com/docs)
- [Gemini Documentation](https://ai.google.dev/gemini-api/docs/models)
- [Google AI Studio Documentation](https://ai.google.dev/gemini-api/docs/ai-studio-quickstart)

### บอกเราหน่อยว่า Codelab ชุดนี้เป็นอย่างไรบ้าง
- [Feedback form](https://forms.gle/xXkqeFE3vLSubP1f9)


