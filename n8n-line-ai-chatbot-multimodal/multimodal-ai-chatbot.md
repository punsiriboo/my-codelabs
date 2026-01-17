
id: n8n-line-ai-agent-multimodal
title: Build a Smart AI Chatbot for Image & Document Understanding using n8n
summary:Codelab นี้คุณจะได้เรียนรู้การสร้าง พัฒนา LINE AI Chatbot ให้รองรับการวิเคราะห์รูปภาพและเอกสารด้วย Google Gemini Vision API
authors: Punsiri Boonyakiat
categories: LINE Messaging API, LINE Chatbot
tags: LINE Messaging API, LINE Chatbot
status: Published
url: n8n-line-ai-agent
Feedback Link: https://forms.gle/xXkqeFE3vLSubP1f9

# Build a Smart AI Chatbot for Image & Document Understanding using n8n

## บทนำ
Duration: 0:05:00

![Title](images/title.png)

"หลังจากที่คุณได้สร้าง LINE AI Chatbot พื้นฐานที่สามารถตอบข้อความได้แล้ว ใน Codelab นี้คุณจะได้เรียนรู้วิธีพัฒนาบอทให้มีความสามารถในการ **เข้าใจและวิเคราะห์รูปภาพและเอกสาร** ด้วย Google Gemini Vision API"

Codelab นี้เป็นส่วนต่อจาก Codelab แรก **"Build a Smart AI Chatbot without Coding using n8n"** ซึ่งคุณควรจะได้สร้าง LINE AI Chatbot พื้นฐานที่สามารถ:
- รับและตอบข้อความจากผู้ใช้
- ใช้ Google Gemini เพื่อประมวลผลและตอบคำถาม
- ส่ง LINE Flex Message ได้

ใน Codelab นี้ คุณจะได้เรียนรู้วิธีเพิ่มความสามารถให้บอทสามารถ:
- **วิเคราะห์รูปภาพ**: อธิบายเนื้อหาในรูปภาพ, อ่านข้อความในรูปภาพ (OCR), วิเคราะห์เมนูอาหารจากรูปภาพ
- **วิเคราะห์เอกสาร**: อ่านและสรุปเอกสาร PDF, Word, Excel ที่ผู้ใช้ส่งมา
- **Multimodal Understanding**: เข้าใจทั้งข้อความและรูปภาพพร้อมกัน

![Architecture](images/architecture.png)

### สิ่งที่คุณจะได้ลงมือทำ
- เรียนรู้การทำงานของ LINE Content API
- ตั้งค่า workflow เพื่อรับรูปภาพและเอกสารจาก LINE
- ดึง Content URL จาก LINE Messaging API
- เชื่อมต่อ Google Gemini Vision API เพื่อวิเคราะห์รูปภาพและเอกสาร
- สร้าง AI Agent ที่สามารถประมวลผลทั้งข้อความและรูปภาพพร้อมกัน

### สิ่งที่คุณจะได้เรียนรู้

- **LINE Content API**: เรียนรู้วิธีดึงรูปภาพและไฟล์จาก LINE
- **Multimodal AI**: เข้าใจหลักการทำงานของ Vision AI และการประมวลผลหลายรูปแบบข้อมูล
- **Google Gemini Vision**: เรียนรู้วิธีใช้ Gemini API เพื่อวิเคราะห์รูปภาพและเอกสาร
- **Workflow Design**: ออกแบบ workflow ที่ซับซ้อนขึ้นเพื่อจัดการกับหลายประเภทข้อมูล

### สิ่งที่คุณต้องเตรียมพร้อมก่อนเริ่ม Codelab 

- **LINE AI Chatbot ที่สร้างจาก Codelab แรก** – ต้องมี workflow พื้นฐานที่ทำงานได้แล้ว
- **n8n instance ที่ deploy บน Render** – ต้องสามารถเข้าถึงและแก้ไข workflow ได้
- **[บัญชี Google](https://accounts.google.com/lifecycle/steps/signup/)** – สำหรับใช้ Google Gemini API (ควรมี API Key อยู่แล้วจาก Codelab แรก)
- **รูปภาพและเอกสารสำหรับทดสอบ** – เตรียมรูปภาพหรือไฟล์ PDF/Word/Excel เพื่อทดสอบ

<aside class="positive">
<strong>Note:</strong> Codelab นี้ต่อเนื่องจาก Codelab แรก หากคุณยังไม่ได้สร้าง LINE AI Chatbot พื้นฐาน กรุณาไปทำ Codelab แรกก่อน
</aside>

## ทำความรู้จักกับ LINE Content API
Duration: 0:10:00

### LINE Content API คืออะไร?

**LINE Content API** คือ API ที่ให้บริการโดย LINE Corporation สำหรับการจัดการเนื้อหา (Content) ที่ผู้ใช้ส่งมาผ่าน LINE Messaging API เช่น รูปภาพ, ไฟล์, วิดีโอ, เสียง

เมื่อผู้ใช้ส่งรูปภาพหรือไฟล์มาที่ LINE Chatbot:
1. LINE จะเก็บเนื้อหาไว้ใน LINE Platform
2. LINE จะส่ง Webhook event พร้อมกับ **Content URL** มาที่ Webhook Server ของเรา
3. เราต้องใช้ **Content API** เพื่อดึงเนื้อหาจริงจาก LINE Platform
4. จากนั้นจึงส่งเนื้อหานั้นไปยัง AI Model เพื่อวิเคราะห์

![LINE Content API Flow](images/3.1.png)

### ประเภทของ Content ที่ LINE รองรับ

LINE Messaging API รองรับการรับเนื้อหาหลายประเภท:

| **ประเภท** | **Message Type** | **ขนาดสูงสุด** | **การใช้งาน** |
|:---|:---|:---|:---|
| รูปภาพ | `image` | 10 MB | วิเคราะห์รูปภาพ, OCR |
| ไฟล์ | `file` | 200 MB | อ่านเอกสาร PDF, Word, Excel |
| วิดีโอ | `video` | 200 MB | วิเคราะห์วิดีโอ (ขั้นสูง) |
| เสียง | `audio` | 200 MB | วิเคราะห์เสียง (ขั้นสูง) |

<aside class="positive">
<strong>Note:</strong> ใน Codelab นี้เราจะเน้นที่ **รูปภาพ** และ **ไฟล์** เป็นหลัก
</aside>

### โครงสร้าง Webhook Event สำหรับรูปภาพและไฟล์

เมื่อผู้ใช้ส่งรูปภาพหรือไฟล์มา LINE จะส่ง Webhook event ในรูปแบบ JSON ดังนี้:

**ตัวอย่าง: รูปภาพ**
```json
{
  "type": "message",
  "message": {
    "id": "1234567890",
    "type": "image",
    "contentProvider": {
      "type": "line"
    }
  },
  "source": {
    "type": "user",
    "userId": "U1234567890abcdef"
  },
  "replyToken": "replyToken1234567890",
  "timestamp": 1234567890123
}
```

**ตัวอย่าง: ไฟล์**
```json
{
  "type": "message",
  "message": {
    "id": "1234567890",
    "type": "file",
    "fileName": "document.pdf",
    "fileSize": 1024000
  },
  "source": {
    "type": "user",
    "userId": "U1234567890abcdef"
  },
  "replyToken": "replyToken1234567890",
  "timestamp": 1234567890123
}
```

### การดึง Content จาก LINE

เพื่อดึงเนื้อหาจริงจาก LINE Platform เราต้อง:

1. **ใช้ Message ID** จาก Webhook event
2. **เรียก LINE Content API** ด้วย Channel Access Token
3. **รับ Binary Data** (รูปภาพหรือไฟล์) กลับมา
4. **แปลงเป็น Base64** หรือ **Upload ไปยัง Temporary Storage** เพื่อส่งไปยัง AI Model

![LINE Content API Process](images/3.2.png)

<aside class="negative">
<strong>Important:</strong> Content URL จาก LINE มีอายุจำกัด (ประมาณ 1 วัน) และต้องใช้ Channel Access Token ในการเข้าถึง
</aside>

## ทำความรู้จักกับ Multimodal AI และ Google Gemini Vision
Duration: 0:10:00

### Multimodal AI คืออะไร?

**Multimodal AI** คือ AI ที่สามารถประมวลผลข้อมูลหลายรูปแบบพร้อมกัน เช่น:
- **Text**: ข้อความ
- **Image**: รูปภาพ
- **Audio**: เสียง
- **Video**: วิดีโอ

แตกต่างจาก AI แบบเดิมที่ประมวลผลได้แค่ข้อความเท่านั้น Multimodal AI สามารถ:
- **เข้าใจบริบท**: เชื่อมโยงข้อมูลระหว่างข้อความและรูปภาพ
- **วิเคราะห์ภาพ**: อธิบายเนื้อหา, อ่านข้อความในรูป (OCR), วิเคราะห์อารมณ์
- **ประมวลผลเอกสาร**: อ่านและสรุปเอกสาร PDF, Word, Excel

![Multimodal AI](images/7.1.png)

### Google Gemini Vision API

**Google Gemini** เป็น LLM ที่รองรับ Multimodal โดยสามารถ:
- รับทั้งข้อความและรูปภาพพร้อมกัน
- วิเคราะห์และตอบคำถามเกี่ยวกับรูปภาพ
- อ่านข้อความในรูปภาพ (OCR)
- สรุปเอกสารจากรูปภาพ

#### โมเดลที่รองรับ Vision

| **โมเดล** | **ความสามารถ** | **Rate Limit** |
|:---|:---|:---|
| `gemini-2.0-flash-exp` | รองรับ Vision, เร็ว | สูง |
| `gemini-1.5-pro` | รองรับ Vision, แม่นยำ | ปานกลาง |
| `gemini-1.5-flash` | รองรับ Vision, เร็ว | สูง |

<aside class="positive">
<strong>Tip:</strong> สำหรับการใช้งานทั่วไป แนะนำใช้ `gemini-2.0-flash-exp` หรือ `gemini-1.5-flash` เพื่อความเร็ว
</aside>

### วิธีการส่งรูปภาพไปยัง Gemini

Google Gemini API รองรับการส่งรูปภาพในหลายรูปแบบ:

#### 1. **Base64 Encoding** (แนะนำ)
- แปลงรูปภาพเป็น Base64 string
- ส่งไปพร้อมกับ prompt ใน request

#### 2. **File URI** (สำหรับไฟล์ในเครื่อง)
- ใช้ file:// URI (สำหรับ local files)

#### 3. **Data URI**
- ใช้ data:image/jpeg;base64,... format

<aside class="negative">
<strong>Note:</strong> Gemini API ไม่รองรับการส่ง URL โดยตรง ต้องแปลงเป็น Base64 ก่อน
</aside>

### ตัวอย่างการใช้งาน Gemini Vision

**Prompt พร้อมรูปภาพ:**
```
"รูปภาพนี้แสดงอะไร? อธิบายรายละเอียดให้หน่อย"
+ [รูปภาพ]
```

**ผลลัพธ์:**
```
"รูปภาพนี้แสดงเมนูอาหารไทย มีกะเพราหมูไข่ดาว ราคา 50 บาท, 
ข้าวผัดกุ้ง ราคา 60 บาท, และผัดไทยกุ้งสด ราคา 80 บาท..."
```

## เพิ่มความสามารถรับรูปภาพใน Workflow
Duration: 0:15:00

ในส่วนนี้คุณจะได้เรียนรู้วิธีเพิ่มความสามารถให้ Chatbot รับและประมวลผลรูปภาพจากผู้ใช้

### ขั้นตอนทั้งหมด

1. ตรวจสอบประเภทข้อความ (Message Type)
2. ดึง Content URL จาก LINE
3. ดาวน์โหลดรูปภาพจาก LINE Content API
4. แปลงรูปภาพเป็น Base64
5. ส่งไปยัง Gemini Vision API
6. ส่งคำตอบกลับไปยังผู้ใช้

---

### 1. ตรวจสอบประเภทข้อความ (Message Type)

ก่อนอื่นเราต้องตรวจสอบว่าผู้ใช้ส่งอะไรมาบ้าง (ข้อความ, รูปภาพ, หรือไฟล์)

1.1. เปิด workflow ที่สร้างไว้จาก Codelab แรก

1.2. เพิ่ม **IF Node** ระหว่าง **Line Messaging Trigger** และ **AI Agent**

1.3. ตั้งค่า IF Node:
   - **Condition 1**: 
     - **Value 1**: `{{ $("Line Messaging Trigger").item.json.message.type }}`
     - **Operation**: `equals`
     - **Value 2**: `text`
   - **Add Condition**: เพิ่ม Condition 2
   - **Condition 2**:
     - **Value 1**: `{{ $("Line Messaging Trigger").item.json.message.type }}`
     - **Operation**: `equals`
     - **Value 2**: `image`

![IF Node Setup](images/8.1.png)

<aside class="positive">
<strong>Note:</strong> IF Node จะแยก flow ตามประเภทข้อความ: ข้อความปกติ (text) ไปทางหนึ่ง, รูปภาพ (image) ไปอีกทางหนึ่ง
</aside>

### 2. ดึง Content URL จาก LINE

เมื่อผู้ใช้ส่งรูปภาพมา เราต้องดึง Content URL จาก LINE

2.1. เพิ่ม **HTTP Request Node** ใน branch ของรูปภาพ (image)

2.2. ตั้งค่า HTTP Request Node:
   - **Method**: `GET`
   - **URL**: 
     ```
     https://api-data.line.me/v2/bot/message/{{ $("Line Messaging Trigger").item.json.message.id }}/content
     ```
   - **Authentication**: `Generic Credential Type`
   - **Credential Type**: `Header Auth`
   - **Name**: `Authorization`
   - **Value**: `Bearer {{ $("Line Messaging Trigger").item.json.credentials.lineMessagingApi.accessToken }}`

![HTTP Request for Content](images/8.2.png)

<aside class="negative">
<strong>Important:</strong> ต้องใช้ Channel Access Token ที่ถูกต้องในการดึง Content จาก LINE
</aside>

### 3. แปลงรูปภาพเป็น Base64

Gemini API ต้องการรูปภาพในรูปแบบ Base64

3.1. เพิ่ม **Code Node** หลัง HTTP Request Node

3.2. ใส่โค้ดต่อไปนี้ใน Code Node:

```javascript
// ดึง binary data จาก HTTP Request
const imageData = $input.item.binary.data;

// แปลงเป็น Base64
const base64Image = imageData.data.toString('base64');

// กำหนด MIME type (สำหรับรูปภาพ LINE มักเป็น image/jpeg)
const mimeType = 'image/jpeg';

// สร้าง data URI format
const dataUri = `data:${mimeType};base64,${base64Image}`;

return {
  json: {
    imageBase64: base64Image,
    imageDataUri: dataUri,
    mimeType: mimeType,
    // เก็บข้อมูลเดิมไว้
    originalMessage: $("Line Messaging Trigger").item.json,
    userMessage: $("Line Messaging Trigger").item.json.message.type === 'image' 
      ? 'ช่วยวิเคราะห์รูปภาพนี้ให้หน่อย' 
      : $("Line Messaging Trigger").item.json.message.text
  }
};
```

![Code Node for Base64](images/8.3.png)

### 4. ส่งไปยัง Gemini Vision API

4.1. เพิ่ม **AI Agent Node** ใน branch ของรูปภาพ

4.2. ตั้งค่า AI Agent Node:
   - **Source for Prompt**: `Define below`
   - **Prompt (User Message)**: 
     ```
     {{ $("Code").item.json.userMessage }}
     ```
   - **System Message**: 
     ```
     คุณเป็นผู้ช่วย AI ที่สามารถวิเคราะห์รูปภาพได้ 
     เมื่อได้รับรูปภาพมา ให้อธิบายรายละเอียดในรูปภาพอย่างละเอียด
     หากเป็นเมนูอาหาร ให้อ่านรายการอาหารและราคาให้ครบถ้วน
     ```

4.3. เพิ่ม **Google Gemini Chat Model**:
   - **Model**: `models/gemini-2.0-flash-exp` หรือ `models/gemini-1.5-flash`
   - **Options** → **Vision** → **Enable Vision**

4.4. ในส่วน **Vision Input**:
   - **Add Vision Input**
   - **Type**: `Image`
   - **Image Data**: `{{ $("Code").item.json.imageDataUri }}`

![AI Agent Vision Setup](images/8.4.png)

### 5. ส่งคำตอบกลับไปยังผู้ใช้

5.1. เชื่อมต่อ **Line Messaging Reply Node** หลัง AI Agent

5.2. ตั้งค่า Reply Node:
   - **Reply Token**: `{{ $("Line Messaging Trigger").item.json.replyToken }}`
   - **Text**: `{{ $("AI Agent").item.json.output }}`

![Complete Image Workflow](images/8.5.png)

### 6. ทดสอบการรับรูปภาพ

6.1. **Save** และ **Publish** workflow

6.2. ส่งรูปภาพไปที่ LINE Chatbot

6.3. ตรวจสอบว่า Chatbot ตอบกลับมาด้วยการวิเคราะห์รูปภาพ

![Test Image](images/8.6.png)

## เพิ่มความสามารถรับเอกสารใน Workflow
Duration: 0:15:00

ในส่วนนี้คุณจะได้เรียนรู้วิธีเพิ่มความสามารถให้ Chatbot รับและอ่านเอกสาร (PDF, Word, Excel) จากผู้ใช้

### ขั้นตอนทั้งหมด

1. เพิ่ม Condition สำหรับไฟล์ (File Type)
2. ดาวน์โหลดไฟล์จาก LINE Content API
3. แปลงไฟล์เป็นรูปภาพ (สำหรับ PDF) หรือ Text
4. ส่งไปยัง Gemini เพื่อสรุปเอกสาร
5. ส่งคำตอบกลับไปยังผู้ใช้

---

### 1. เพิ่ม Condition สำหรับไฟล์

1.1. แก้ไข **IF Node** ที่สร้างไว้ก่อนหน้า

1.2. เพิ่ม **Condition 3**:
   - **Value 1**: `{{ $("Line Messaging Trigger").item.json.message.type }}`
   - **Operation**: `equals`
   - **Value 2**: `file`

![IF Node with File](images/9.1.png)

### 2. ดาวน์โหลดไฟล์จาก LINE

2.1. เพิ่ม **HTTP Request Node** ใน branch ของไฟล์ (file)

2.2. ตั้งค่าเหมือนกับตอนดึงรูปภาพ:
   - **Method**: `GET`
   - **URL**: 
     ```
     https://api-data.line.me/v2/bot/message/{{ $("Line Messaging Trigger").item.json.message.id }}/content
     ```
   - **Authentication**: `Header Auth`
   - **Authorization**: `Bearer {{ $("Line Messaging Trigger").item.json.credentials.lineMessagingApi.accessToken }}`

### 3. ตรวจสอบประเภทไฟล์และประมวลผล

3.1. เพิ่ม **Code Node** เพื่อตรวจสอบประเภทไฟล์

3.2. ใส่โค้ดต่อไปนี้:

```javascript
const fileName = $("Line Messaging Trigger").item.json.message.fileName || '';
const fileExtension = fileName.split('.').pop().toLowerCase();
const fileData = $input.item.binary.data;

let processedData = null;
let mimeType = 'application/octet-stream';

// ตรวจสอบประเภทไฟล์
if (fileExtension === 'pdf') {
  // สำหรับ PDF: แปลงเป็น Base64 (Gemini รองรับ PDF โดยตรง)
  processedData = fileData.data.toString('base64');
  mimeType = 'application/pdf';
} else if (['jpg', 'jpeg', 'png', 'gif'].includes(fileExtension)) {
  // สำหรับรูปภาพ: แปลงเป็น Base64
  processedData = fileData.data.toString('base64');
  mimeType = `image/${fileExtension === 'jpg' ? 'jpeg' : fileExtension}`;
} else {
  // สำหรับไฟล์อื่นๆ: ลองแปลงเป็น text
  try {
    processedData = fileData.data.toString('utf-8');
    mimeType = 'text/plain';
  } catch (e) {
    processedData = fileData.data.toString('base64');
  }
}

return {
  json: {
    fileName: fileName,
    fileExtension: fileExtension,
    fileBase64: processedData,
    mimeType: mimeType,
    originalMessage: $("Line Messaging Trigger").item.json,
    userMessage: `ช่วยสรุปเอกสารนี้ให้หน่อย: ${fileName}`
  }
};
```

![Code Node for File](images/9.2.png)

<aside class="positive">
<strong>Note:</strong> Google Gemini รองรับ PDF โดยตรง แต่สำหรับ Word และ Excel อาจต้องแปลงเป็น PDF หรือ Text ก่อน
</aside>

### 4. ส่งไปยัง Gemini เพื่อสรุปเอกสาร

4.1. เพิ่ม **AI Agent Node** ใน branch ของไฟล์

4.2. ตั้งค่า AI Agent:
   - **Prompt**: `{{ $("Code").item.json.userMessage }}`
   - **System Message**: 
     ```
     คุณเป็นผู้ช่วย AI ที่สามารถอ่านและสรุปเอกสารได้
     เมื่อได้รับเอกสารมา ให้สรุปเนื้อหาหลักและประเด็นสำคัญให้ครบถ้วน
     หากเป็นเอกสารทางการ ให้ระบุวันที่, จำนวนเงิน, หรือข้อมูลสำคัญอื่นๆ
     ```

4.3. เพิ่ม **Google Gemini Chat Model**:
   - **Model**: `models/gemini-1.5-pro` (แนะนำสำหรับเอกสารที่ซับซ้อน)
   - **Max Output Tokens**: `1000`

4.4. สำหรับ **PDF Files**:
   - **Add Vision Input** → **Type**: `File`
   - **File Data**: `{{ $("Code").item.json.fileBase64 }}`
   - **MIME Type**: `{{ $("Code").item.json.mimeType }}`

![AI Agent for Document](images/9.3.png)

### 5. ส่งคำตอบกลับ

5.1. เชื่อมต่อ **Line Messaging Reply Node**

5.2. ตั้งค่าเหมือนเดิม:
   - **Reply Token**: `{{ $("Line Messaging Trigger").item.json.replyToken }}`
   - **Text**: `{{ $("AI Agent").item.json.output }}`

![Complete File Workflow](images/9.4.png)

### 6. ทดสอบการรับเอกสาร

6.1. **Save** และ **Publish** workflow

6.2. ส่งไฟล์ PDF ไปที่ LINE Chatbot

6.3. ตรวจสอบว่า Chatbot สรุปเอกสารได้ถูกต้อง

![Test Document](images/9.5.png)

## ปรับปรุง AI Agent ให้รองรับ Multimodal Input
Duration: 0:10:00

ในส่วนนี้คุณจะได้เรียนรู้วิธีปรับปรุง AI Agent ให้สามารถประมวลผลทั้งข้อความและรูปภาพพร้อมกัน (Multimodal Input)

### ขั้นตอนทั้งหมด

1. รวม Workflow ทั้งหมดเข้าด้วยกัน
2. ปรับ System Prompt ให้รองรับ Multimodal
3. เพิ่ม Logic สำหรับกรณีที่ผู้ใช้ส่งทั้งข้อความและรูปภาพ
4. ทดสอบ Multimodal Input

---

### 1. รวม Workflow ทั้งหมด

1.1. ตรวจสอบว่า Workflow มี 3 branches:
   - **Text messages** → AI Agent (ข้อความ)
   - **Image messages** → Download → Convert → AI Agent (Vision)
   - **File messages** → Download → Convert → AI Agent (Document)

1.2. ตรวจสอบว่าแต่ละ branch เชื่อมต่อกับ **Line Messaging Reply Node** ที่ถูกต้อง

![Complete Multimodal Workflow](images/10.1.png)

### 2. ปรับ System Prompt

2.1. ไปที่ **AI Agent Node** ในแต่ละ branch

2.2. ปรับ **System Message** ให้เหมาะสม:

**สำหรับ Text Branch:**
```
คุณเป็นผู้ช่วย AI สำหรับร้านอาหารไทย
ตอบคำถามเกี่ยวกับเมนู, รับออร์เดอร์, และให้ข้อมูลเกี่ยวกับร้าน
```

**สำหรับ Image Branch:**
```
คุณเป็นผู้ช่วย AI ที่สามารถวิเคราะห์รูปภาพได้
- หากเป็นเมนูอาหาร: อ่านรายการและราคาให้ครบถ้วน
- หากเป็นรูปอาหาร: อธิบายรายละเอียดและแนะนำเมนูที่เกี่ยวข้อง
- หากเป็นเอกสาร: สรุปเนื้อหาหลัก
```

**สำหรับ File Branch:**
```
คุณเป็นผู้ช่วย AI ที่สามารถอ่านและสรุปเอกสารได้
สรุปเนื้อหาหลัก, ประเด็นสำคัญ, และข้อมูลที่เกี่ยวข้อง
```

### 3. เพิ่ม Memory ให้ทุก Branch

3.1. เพิ่ม **Simple Memory Node** ให้ทุก AI Agent

3.2. ตั้งค่า Session ID เหมือนกันทุก branch:
   - **Session ID**: `{{ $("Line Messaging Trigger").item.json.source.userId }}`

<aside class="positive">
<strong>Tip:</strong> การใช้ Session ID เดียวกันจะทำให้ AI จำบริบทจากการสนทนาก่อนหน้าได้ แม้ว่าผู้ใช้จะส่งข้อความ, รูปภาพ, หรือไฟล์สลับกัน
</aside>

### 4. ทดสอบ Multimodal Input

4.1. **Save** และ **Publish** workflow

4.2. ทดสอบหลายๆ สถานการณ์:
   - ส่งข้อความ: "สวัสดี"
   - ส่งรูปภาพเมนูอาหาร
   - ส่งข้อความต่อ: "มีอะไรแนะนำบ้าง"
   - ส่งไฟล์ PDF

4.3. ตรวจสอบว่า AI จำบริบทและตอบได้อย่างต่อเนื่อง

![Test Multimodal](images/10.2.png)

## สร้าง Use Case: วิเคราะห์เมนูอาหารจากรูปภาพ
Duration: 0:15:00

ในส่วนนี้คุณจะได้สร้าง Use Case จริง: ให้ Chatbot วิเคราะห์เมนูอาหารจากรูปภาพและแนะนำเมนูที่เกี่ยวข้อง

### ขั้นตอนทั้งหมด

1. ปรับ System Prompt สำหรับวิเคราะห์เมนู
2. เพิ่ม Logic สำหรับแนะนำเมนู
3. สร้าง LINE Flex Message สำหรับแสดงเมนูที่แนะนำ
4. ทดสอบ Use Case

---

### 1. ปรับ System Prompt

1.1. ไปที่ **AI Agent Node** ใน Image branch

1.2. ปรับ **System Message**:

```
# Instruction: AI Assistant สำหรับวิเคราะห์เมนูอาหาร

## 1. หน้าที่หลัก
- วิเคราะห์รูปภาพเมนูอาหาร
- อ่านรายการอาหารและราคาให้ครบถ้วน
- แนะนำเมนูที่เกี่ยวข้องจากเมนูที่มีในร้าน

## 2. เมนูที่มีในร้าน
### 2.1 เมนูข้าวแกง
- กะเพราหมูไข่ดาว — 50 บาท
- ข้าวผัดกุ้ง — 60 บาท
- ผัดไทยกุ้งสด — 80 บาท

### 2.2 เมนูตำ/ยำ
- ส้มตำไทย — 45 บาท
- ส้มตำปูปลาร้า — 50 บาท
- ลาบหมู — 65 บาท

### 2.3 เครื่องดื่ม
- น้ำเก๊กฮวย — 20 บาท
- น้ำลำไย — 20 บาท
- น้ำเปล่า — 10 บาท

## 3. วิธีการตอบกลับ
3.1 หากรูปภาพเป็นเมนู:
- อ่านรายการอาหารและราคาทั้งหมด
- เปรียบเทียบกับเมนูที่มีในร้าน
- แนะนำเมนูที่คล้ายกันหรือเกี่ยวข้อง

3.2 หากรูปภาพเป็นอาหารที่ทาน:
- อธิบายรายละเอียดอาหาร
- แนะนำเมนูที่เกี่ยวข้องจากเมนูในร้าน
- ถามว่าต้องการสั่งอาหารหรือไม่

## 4. ข้อจำกัด
- ห้ามแต่งเมนูหรือราคาเพิ่มจากที่กำหนด
- ต้องตอบเป็นภาษาไทยเท่านั้น
- หากไม่แน่ใจ ให้ถามผู้ใช้แทนการเดา
```

![System Prompt for Menu](images/11.1.png)

### 2. เพิ่ม Tool สำหรับส่ง LINE Flex Message

2.1. ไปที่ **AI Agent Node** ใน Image branch

2.2. เพิ่ม **Line Messaging Tool** (ถ้ายังไม่มี)

2.3. ตั้งค่า Tool:
   - **Operation**: `Send`
   - **User ID**: `{{ $("Line Messaging Trigger").item.json.source.userId }}`
   - **Messages**: LINE Flex Message (ใช้ JSON เดิมจาก Codelab แรก)

### 3. ปรับ System Prompt ให้เรียกใช้ Tool

3.1. เพิ่มคำสั่งใน **System Message**:

```
## 5. การใช้ Tools
เมื่อวิเคราะห์เมนูเสร็จแล้ว:
- หากผู้ใช้ถามเกี่ยวกับเมนู หรือต้องการดูเมนู
- ให้เรียกใช้ Tool: Send LINE Flex Message เพื่อแสดงเมนูแนะนำ
```

![Tool Integration](images/11.2.png)

### 4. ทดสอบ Use Case

4.1. **Save** และ **Publish** workflow

4.2. ส่งรูปภาพเมนูอาหารไปที่ Chatbot

4.3. ตรวจสอบว่า:
   - Chatbot อ่านเมนูจากรูปภาพได้ถูกต้อง
   - Chatbot แนะนำเมนูที่เกี่ยวข้อง
   - Chatbot สามารถส่ง LINE Flex Message ได้

![Test Menu Analysis](images/11.3.png)

## สร้าง Use Case: อ่านและสรุปเอกสาร
Duration: 0:15:00

ในส่วนนี้คุณจะได้สร้าง Use Case: ให้ Chatbot อ่านและสรุปเอกสาร PDF, Word, Excel

### ขั้นตอนทั้งหมด

1. ปรับ System Prompt สำหรับสรุปเอกสาร
2. เพิ่ม Logic สำหรับจัดการเอกสารหลายประเภท
3. สร้าง Template สำหรับสรุปเอกสาร
4. ทดสอบ Use Case

---

### 1. ปรับ System Prompt

1.1. ไปที่ **AI Agent Node** ใน File branch

1.2. ปรับ **System Message**:

```
# Instruction: AI Assistant สำหรับสรุปเอกสาร

## 1. หน้าที่หลัก
- อ่านและสรุปเอกสารที่ผู้ใช้ส่งมา
- แยกประเด็นสำคัญและข้อมูลที่เกี่ยวข้อง
- จัดรูปแบบการสรุปให้อ่านง่าย

## 2. รูปแบบการสรุป
### 2.1 สำหรับเอกสารทั่วไป
- **หัวข้อหลัก**: สรุปหัวข้อหลักของเอกสาร
- **ประเด็นสำคัญ**: แยกประเด็นสำคัญเป็น bullet points
- **ข้อมูลสำคัญ**: ระบุวันที่, จำนวนเงิน, ชื่อบุคคล, หรือข้อมูลสำคัญอื่นๆ

### 2.2 สำหรับเอกสารทางการ (Invoice, Receipt)
- **ประเภทเอกสาร**: ระบุประเภท (ใบแจ้งหนี้, ใบเสร็จ, ฯลฯ)
- **วันที่**: ระบุวันที่ในเอกสาร
- **จำนวนเงิน**: ระบุยอดรวม
- **รายละเอียด**: สรุปรายการสินค้าหรือบริการ

### 2.3 สำหรับเอกสารสัญญา
- **ประเภทสัญญา**: ระบุประเภทสัญญา
- **คู่สัญญา**: ระบุชื่อคู่สัญญา
- **เงื่อนไขสำคัญ**: สรุปเงื่อนไขหลัก
- **วันที่เริ่มต้น/สิ้นสุด**: ระบุระยะเวลาสัญญา

## 3. วิธีการตอบกลับ
- ใช้ภาษาไทยที่เข้าใจง่าย
- จัดรูปแบบด้วย Markdown (ใช้ **สำหรับหัวข้อ, - สำหรับรายการ)
- หากเอกสารยาว ให้สรุปเฉพาะประเด็นสำคัญ
- หากมีข้อมูลไม่ชัดเจน ให้ระบุว่า "ไม่พบข้อมูล" แทนการเดา

## 4. ข้อจำกัด
- ห้ามแต่งข้อมูลเพิ่มเติม
- ต้องอ้างอิงจากเอกสารเท่านั้น
- หากไม่แน่ใจ ให้ระบุว่า "ไม่สามารถระบุได้"
```

![System Prompt for Document](images/12.1.png)

### 2. เพิ่ม Logic สำหรับจัดการเอกสารหลายประเภท

2.1. แก้ไข **Code Node** ใน File branch

2.2. เพิ่มการตรวจสอบประเภทเอกสาร:

```javascript
const fileName = $("Line Messaging Trigger").item.json.message.fileName || '';
const fileExtension = fileName.split('.').pop().toLowerCase();
const fileData = $input.item.binary.data;

let processedData = null;
let mimeType = 'application/octet-stream';
let documentType = 'general';

// ตรวจสอบประเภทไฟล์
if (fileExtension === 'pdf') {
  processedData = fileData.data.toString('base64');
  mimeType = 'application/pdf';
  
  // ตรวจสอบประเภทเอกสารจากชื่อไฟล์
  const lowerFileName = fileName.toLowerCase();
  if (lowerFileName.includes('invoice') || lowerFileName.includes('ใบแจ้งหนี้')) {
    documentType = 'invoice';
  } else if (lowerFileName.includes('receipt') || lowerFileName.includes('ใบเสร็จ')) {
    documentType = 'receipt';
  } else if (lowerFileName.includes('contract') || lowerFileName.includes('สัญญา')) {
    documentType = 'contract';
  }
} else if (['jpg', 'jpeg', 'png'].includes(fileExtension)) {
  processedData = fileData.data.toString('base64');
  mimeType = `image/${fileExtension === 'jpg' ? 'jpeg' : fileExtension}`;
  documentType = 'image';
} else {
  try {
    processedData = fileData.data.toString('utf-8');
    mimeType = 'text/plain';
  } catch (e) {
    processedData = fileData.data.toString('base64');
  }
}

return {
  json: {
    fileName: fileName,
    fileExtension: fileExtension,
    fileBase64: processedData,
    mimeType: mimeType,
    documentType: documentType,
    originalMessage: $("Line Messaging Trigger").item.json,
    userMessage: `ช่วยสรุปเอกสารนี้ให้หน่อย (ประเภท: ${documentType}): ${fileName}`
  }
};
```

![Code Node Enhanced](images/12.2.png)

### 3. ปรับ System Prompt ตามประเภทเอกสาร

3.1. เพิ่ม **IF Node** หลัง Code Node

3.2. แยก flow ตาม `documentType`:
   - `invoice` / `receipt` → AI Agent (Financial Document)
   - `contract` → AI Agent (Contract Document)
   - อื่นๆ → AI Agent (General Document)

3.3. ตั้งค่า System Prompt แต่ละประเภท:

**Financial Document:**
```
คุณเป็นผู้ช่วย AI สำหรับสรุปเอกสารทางการเงิน
เน้นที่: วันที่, จำนวนเงิน, รายการสินค้า/บริการ, ข้อมูลผู้ขาย/ผู้ซื้อ
```

**Contract Document:**
```
คุณเป็นผู้ช่วย AI สำหรับสรุปสัญญา
เน้นที่: ประเภทสัญญา, คู่สัญญา, เงื่อนไขสำคัญ, ระยะเวลา
```

### 4. ทดสอบ Use Case

4.1. **Save** และ **Publish** workflow

4.2. ส่งเอกสารหลายประเภท:
   - PDF Invoice
   - PDF Contract
   - รูปภาพเอกสาร

4.3. ตรวจสอบว่า Chatbot สรุปได้ถูกต้องตามประเภทเอกสาร

![Test Document Summary](images/12.3.png)

## ปรับปรุงและเพิ่มประสิทธิภาพ
Duration: 0:10:00

ในส่วนนี้คุณจะได้เรียนรู้เทคนิคการปรับปรุงและเพิ่มประสิทธิภาพให้กับ Multimodal Chatbot

### ขั้นตอนทั้งหมด

1. เพิ่ม Error Handling
2. เพิ่ม Validation สำหรับไฟล์ขนาดใหญ่
3. เพิ่ม Caching สำหรับรูปภาพที่วิเคราะห์แล้ว
4. ปรับปรุง User Experience

---

### 1. เพิ่ม Error Handling

1.1. เพิ่ม **Error Trigger Node** ใน workflow

1.2. เชื่อมต่อกับทุก Node ที่อาจเกิด Error:
   - HTTP Request (ดึง Content)
   - Code Node (แปลง Base64)
   - AI Agent (ประมวลผล)

1.3. เพิ่ม **Line Messaging Reply Node** ใน Error branch:
   - **Text**: `ขออภัยค่ะ เกิดข้อผิดพลาดในการประมวลผล กรุณาลองใหม่อีกครั้ง`

![Error Handling](images/13.1.png)

### 2. เพิ่ม Validation สำหรับไฟล์ขนาดใหญ่

2.1. เพิ่ม **IF Node** หลัง Line Messaging Trigger

2.2. ตรวจสอบขนาดไฟล์:
   - **Condition**: `{{ $("Line Messaging Trigger").item.json.message.fileSize }}` < `10485760` (10 MB สำหรับรูปภาพ)
   - **Condition**: `{{ $("Line Messaging Trigger").item.json.message.fileSize }}` < `209715200` (200 MB สำหรับไฟล์)

2.3. หากไฟล์ใหญ่เกินไป ส่งข้อความแจ้งเตือน:
   - `ขออภัยค่ะ ไฟล์ที่ส่งมามีขนาดใหญ่เกินไป กรุณาส่งไฟล์ที่เล็กกว่า 10 MB (รูปภาพ) หรือ 200 MB (เอกสาร)`

![File Size Validation](images/13.2.png)

### 3. เพิ่ม Loading Message

3.1. เพิ่ม **Line Messaging Reply Node** ทันทีหลังรับข้อความ

3.2. ส่งข้อความ Loading:
   - **Text**: `กำลังประมวลผล... กรุณารอสักครู่ค่ะ`

3.3. ใช้ **Reply Token** จาก Trigger

<aside class="positive">
<strong>Tip:</strong> การส่ง Loading Message จะทำให้ผู้ใช้รู้ว่าระบบกำลังทำงาน และไม่ต้องรอนานโดยไม่รู้ว่าเกิดอะไรขึ้น
</aside>

### 4. ปรับปรุง User Experience

4.1. เพิ่มข้อความแนะนำเมื่อผู้ใช้ส่งรูปภาพหรือไฟล์:
   - `ได้รับรูปภาพ/ไฟล์ของคุณแล้ว กำลังวิเคราะห์...`

4.2. เพิ่มข้อความเมื่อไม่สามารถประมวลผลได้:
   - `ไม่สามารถวิเคราะห์ไฟล์ประเภทนี้ได้ กรุณาส่งเป็นรูปภาพ (JPG, PNG) หรือ PDF`

4.3. เพิ่มข้อความยืนยันเมื่อประมวลผลสำเร็จ:
   - `วิเคราะห์เสร็จแล้ว! นี่คือผลลัพธ์:`

![UX Improvements](images/13.3.png)

## Congratulations
Duration: 0:05:00

ยินดีด้วยครับ ถึงตรงนี้คุณก็มี LINE AI Chatbot ที่สามารถวิเคราะห์รูปภาพและเอกสารได้แล้ว!!!

### ใน codelab นี้ คุณได้เรียนรู้:

✅ วิธีการทำงานของ LINE Content API  
✅ วิธีการดึงรูปภาพและไฟล์จาก LINE Platform  
✅ วิธีการใช้ Google Gemini Vision API  
✅ วิธีการสร้าง Multimodal AI Agent  
✅ วิธีการวิเคราะห์รูปภาพและเอกสาร  
✅ วิธีการสร้าง Use Case สำหรับธุรกิจจริง  

### ขั้นตอนถัดไป

- **เพิ่มความสามารถ OCR**: อ่านข้อความจากรูปภาพและแปลงเป็น Text
- **รองรับวิดีโอ**: วิเคราะห์วิดีโอสั้นๆ
- **รองรับเสียง**: แปลงเสียงเป็นข้อความ (Speech-to-Text)
- **เพิ่ม Database**: เก็บประวัติการวิเคราะห์รูปภาพ/เอกสาร
- **เพิ่ม Analytics**: ติดตามสถิติการใช้งาน

### เรียนรู้เพิ่มเติม

- [LINE Content API Documentation](https://developers.line.biz/en/docs/messaging-api/getting-content/)
- [Google Gemini Vision API](https://ai.google.dev/gemini-api/docs/vision)
- [Multimodal AI Best Practices](https://ai.google.dev/gemini-api/docs/multimodal)
- [n8n Error Handling](https://docs.n8n.io/workflows/error-handling/)

### Reference docs

- [LINE Messaging API Documentation](https://developers.line.biz/en/docs/messaging-api/)
- [LINE Content API](https://developers.line.biz/en/docs/messaging-api/getting-content/)
- [Google Gemini API Documentation](https://ai.google.dev/gemini-api/docs)
- [n8n Documentation](https://docs.n8n.io/)
- [n8n HTTP Request Node](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.httprequest/)

### บอกเราหน่อยว่า Codelab ชุดนี้เป็นอย่างไรบ้าง
- [Feedback form](https://forms.gle/xXkqeFE3vLSubP1f9)