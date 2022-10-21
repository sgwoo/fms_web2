<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,java.text.*, acar.common.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.doc_settle.*"%>
<%@ page import="acar.user_mng.*, acar.car_sche.*, acar.fee.*, acar.insur.*, acar.cont.* "%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<!DOCTYPE html>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
<style>
@import url(http://fonts.googleapis.com/earlyaccess/nanumgothic.css);	
@import url(http://fonts.googleapis.com/earlyaccess/nanummyeongjo.css);
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    background-color: #ddd;
   /*  font-family: "맑은 고딕", Malgun Gothic, "굴림", gulim,"돋움", dotum, arial, helvetica, sans-serif; */
}
* {
    box-sizing: border-box;
    -moz-box-sizing: border-box;
}
.paper {
    width: 210mm;
    min-height: 297mm;
    padding: 10mm; /* set contents area */
    margin: 10mm auto;
    border-radius: 5px;
    background: #fff;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}
.content {
    padding: 20px;
   /*  border: 1px #888 solid ; */
    height: 273mm;
}
@page {
    size: A4;
    margin: 0;
}
@media print {
    html, body {
        width: 210mm;
        height: 297mm;
        background: #fff;
    }
    .paper {
        margin: 0;
        border: initial;
        border-radius: initial;
        width: initial;
        min-height: initial;
        box-shadow: initial;
        background: initial;
        page-break-after: always;
    }
   
}
	/* #contents {font-size:9pt}; */
 table {
     border: 2px solid #444444;
    border-collapse: collapse; 
  }
  th, td {
    border: 1px solid #444444;
    font-weight:bold;
    font-size:10.5pt;
    text-align:center;
  }
  input {border:0px;font-size:11pt;font-family: 'Nanum Gothic',sans-serif;}
.title{text-align:center;background-color: #e2e7ff;}  
.contents {font-size:10pt;}
.contents tr{ height:30px;}

#wrap{ font-family: 'Nanum Gothic',sans-serif; vertical-align: middle;}
	
</style>
</head>
<body leftmargin="15" topmargin="1" >

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComDatabase inc_db = InsComDatabase .getInstance();
	
 	String rent_l_cd = request.getParameter("rent_l_cd");
	String rent_mng_id = request.getParameter("rent_mng_id");
	String car_mng_id = request.getParameter("car_mng_id");
	String ins_st = request.getParameter("ins_st");
	
	String vid[] 	= request.getParameterValues("ch_cd"); 
	int vid_size = vid.length;
	
	boolean result = false;
	
	Hashtable ht_ch = new Hashtable(); 
	Vector info = new Vector();
	
	String vid_num		= "";
	String reg_code 	= "";
	String seq 	= "";
	int    idx = 0;
	int    count = 0;
	
	String ins_com_nm ="";
	
	 int info_size = 0;
		
	 Date d = new Date();
	 SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	 String sysdate =   sdf.format(d);	
	
	 for(int i=0;i < vid_size;i++){
		vid_num = vid[i];
		
		int s=0; 
		String app_value[] = new String[7];
		if(vid_num.length() > 0){
			StringTokenizer st = new StringTokenizer(vid_num,"/");
			while(st.hasMoreTokens()){
				app_value[s] = st.nextToken();
				s++;
			}
		}
		reg_code = app_value[0];
		seq = app_value[1];
		idx = AddUtil.parseInt(app_value[2]);
		ht_ch = inc_db.getInsExcelComCase(reg_code,seq);
		
		rent_l_cd = String.valueOf(ht_ch.get("RENT_MNG_ID"));
		rent_mng_id = String.valueOf(ht_ch.get("RENT_L_CD"));
		car_mng_id = String.valueOf(ht_ch.get("CAR_MNG_ID"));
		ins_st =  String.valueOf(ht_ch.get("INS_ST"));
		ins_com_nm =  String.valueOf(ht_ch.get("VALUE09"));
		String ch_dt = String.valueOf(ht_ch.get("VALUE04"));
		String cau = String.valueOf(ht_ch.get("VALUE06"));
		if(ins_com_nm.equals("0008")) ins_com_nm = "DB손해보험";
		else if(ins_com_nm.equals("0038")) ins_com_nm = "렌터카공제조합";
		else if(ins_com_nm.equals("0007")) ins_com_nm = "삼성화재";
		
		result = inc_db.updateInsExcelComConfCng2(reg_code, seq);
		%>
			<script>
				var result= '<%=result%>';
				if(result){
					console.log('<%=reg_code%>' + "/" + '<%=seq%>' + "피보험자 등록완료");
					console.log('<%=rent_l_cd%>' + "/" + '<%=rent_mng_id%>' + "피보험자 등록완료");
					console.log('<%=car_mng_id%>' + "/" + '<%=ins_st%>' + "피보험자 등록완료");
				}else{
					console.log('<%=reg_code%>' + "/" + '<%=seq%>' + "피보험자 등록오류");
				}
			</script>
		<%		
		info = inc_db.getinsConfClsList(car_mng_id, ins_st, reg_code, seq );
		info_size = info.size();
		%>

		<form action="" name="form1" method="POST" >
		    <div class="paper">
		    <div class="content">
				<div id="wrap" style="width:100%;"> 
					<div style="float:left;width:30%">
						<div style="text-align:left;margin-bottom:15px;margin-top:30px;font-size:26pt;font-weight:bold;">
							<img src="/acar/images/big_logo.png"  border="0" align=absmiddle width="300" height=""> 
						</div>
						<div style="text-align:left;font-size:13pt;margin-bottom:10px;font-weight:bold;"></div>
					</div>
					<div style="float:left;width:70%">
						<div style="font-size:10pt;text-align:right;margin-top:60px;font-family:Nanum Myeongjo,serif;font-weight:bold;">
							07236 서울특별시 영등포구 의사당대로 8(태흥빌딩 802호)<br> T)02-392-4243 F)02-757-0803<br> 홈페이지) http://www.amazoncar.co.kr
						</div>	 
					</div>
					<div style="clear:both;"></div>
					<br><hr>
					<div style="text-align:center;font-size:11pt;font-weight:normal;padding:8px;">
						<div>[담당] 총무팀 / 고영은 (직)02-6263-6372, f)02-6944-8451</div>
					</div>
					<hr>
					<div style="text-align:left;font-size:12pt;font-weight:normal;">
						<div style="padding:3px;">&nbsp;수<span style="margin:14px;"></span>신 &nbsp;:&nbsp;&nbsp; <input type="text" value="<%=ins_com_nm %>" style="width:200px;"></div>
						<div style="padding:3px;">&nbsp;발신일자 &nbsp;:&nbsp;&nbsp; <%=sysdate.substring(0,4)%>&nbsp;년&nbsp;&nbsp;<%=sysdate.substring(4,6)%>&nbsp;월&nbsp;&nbsp;<%=sysdate.substring(6,8)%>&nbsp;일</div>
						<div style="padding:3px;">&nbsp;참<span style="margin:14px;"></span>조 &nbsp;:&nbsp;&nbsp; <input type="text" value="" style="width:200px;"></div>
						<div style="padding:3px;">&nbsp;제<span style="margin:14px;"></span>목 &nbsp;:&nbsp;&nbsp; 자동차 리스 계약해지 확인 / 피보험자 변경 </div>
					</div>			
					<hr>
					<div style="text-align:left;font-size:12pt;font-weight:normal;margin-left:90px;">
						<div style="padding:3px;">1. 귀사의 무궁한 발전을 기원합니다.</div>
						<div style="padding:3px;">
							<input type="text" style="width: 100%" value="2. 아래와 같이 당사 자동차 리스 계약자의 계약의 종료(해지) 및 명의이전 되었으므로">
							<br><span style="margin:10px;"></span> 
							<input type="text" style="width: 100%" value="당사 자동차보험의 계약해지를 요청합니다.">
						</div>
						<%if(ins_com_nm.equals("삼성화재") && cau.equals("매입옵션")) { %>
							<div style="padding:3px;">3. 변경일자(반환입고일)&nbsp;:&nbsp;&nbsp; <input type="text" value="<%=ch_dt.substring(0,4)%>&nbsp;년&nbsp;&nbsp;<%=ch_dt.substring(4,6)%>&nbsp;월&nbsp;&nbsp;<%=ch_dt.substring(6,8)%>&nbsp;일" style="width:200px;"> </div>
						<% } else {%>
							<div style="padding:3px;">3. 변경일자(반환입고일)&nbsp;:&nbsp;&nbsp; <input type="text" value="<%=sysdate.substring(0,4)%>&nbsp;년&nbsp;&nbsp;<%=sysdate.substring(4,6)%>&nbsp;월&nbsp;&nbsp;<%=sysdate.substring(6,8)%>&nbsp;일" style="width:200px;"> </div>
						<% } %>
					</div>
					<br>
					<div style="text-align:left;">○ 변경전</div>
					<br>
					<div>
						<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents" style="table-layout:fixed; word-break:break-all;">
							<tr style="height:50;">
								<td width="50" class="">연번</td>				
								<td width="100" class="">차량번호</td>				
								<td width="150" class="">차종</td>				
								<td width="200" class="">계약자<br>(피보험자)</td>				
								<td width="150" class="">주민/사업자등록번호</td>				
							</tr>		
							
							<%for(int j = 0 ; j < info_size ; j++){	
								Hashtable ht = (Hashtable)info.elementAt(j);%>
							 <tr style="height:60;">
								<td><%=j+1%></td>				
								<td><%=ht.get("CAR_NO")%></td>				
								<td><%=ht.get("CAR_NAME")%></td>				
								<td width="200" class=""><input type="text" value="아마존카" style="text-align:center;font-weight:bold"></td>		
								<td width="150" class=""><input type="text" value="128-81-47957" style="text-align:center;font-weight:bold"></td>				
							</tr>		
							<%} %>	
						</table>
					</div>
					<div style="text-align:left;margin-top:40px;">○ 변경후</div>
					<br>
					<div>
						<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents" style="table-layout:fixed; word-break:break-all;">
							<%for(int k = 0 ; k < info_size ; k++){
								Hashtable ht = (Hashtable)info.elementAt(k);%>
							<tr style="height:50;">
								<td width="300" class="">동일기준 적용</td>	
								<td><input type="text" value="<%=ht.get("BEF_FIRM")%>" style="text-align:center;font-weight:bold"></td>				
								<td><input type="text" value="<%=ht.get("BEF_SSN")%>" style="text-align:center;font-weight:bold"></td>				
							</tr>	
							<%} %>				
						</table>
					</div>
					<div style="text-align:center;margin-left:0px;margin-top:200px;font-size:22pt;font-weight:bold;">
						<span style="text-align:left">주식회사&nbsp;&nbsp;아마존카&nbsp;&nbsp;&nbsp;&nbsp;대표이사&nbsp;&nbsp;&nbsp;&nbsp;조&nbsp;&nbsp;성&nbsp;&nbsp;희</span>
						<div id="Layer1" style="position:relative; left:585px; top:-50px; width:79px; height:78px; z-index:1"><img src="/acar/images/stamp.png" width="70" height="71"></div> 
					</div>
				</div>
			</div>
			</div>
		</form>
		<%
	}
%>
</body>
</head>
</html>	
