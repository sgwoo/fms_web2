<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%//@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function onprint(){
factory.printing.header 		= ""; //폐이지상단 인쇄
factory.printing.footer 		= ""; //폐이지하단 인쇄
factory.printing.portrait 		= false; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin 	= 14.0; //좌측여백   
factory.printing.rightMargin 	= 10.0; //우측여백
factory.printing.topMargin 		= 10.0; //상단여백    
factory.printing.bottomMargin 	= 5.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()" >
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<table border="0" cellspacing="0" cellpadding="0" width=940>
    <tr>
	  <td align='center'>(주)아마존카 자동차등록리스트</td>
	</tr>
    <tr>
	  <td align='right'><%=AddUtil.getDate()%></td>
	</tr>
    <tr>
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>
        			<td width='30' class='title'>연번</td>
        			<td width='30' class='title'>구분</td>
        			<td width='150' class='title'>차명</td>
        			<td width='150' class='title'>차대번호</td>
        			<td width='70' class='title'>차량번호</td>
        			<td width='60' class='title'>임시번호</td>
        			<td width='80' class='title'>공급가액</td>
        			<td width='60' class='title'>등록세</td>
        			<td width='60' class='title'>취득세</td>
        			<td width='80' class='title'>법인명</td>
        			<td width='70' class='title'>등록번호</td>
        			<td width='100' class='title'>주소</td>
		        </tr>
		  		  <%	for(int i=0;i < vid_size;i++){
							rent_l_cd = vid[i];
									
							Hashtable ht = a_db.getRentBoardSubCase(rent_l_cd);
									
							total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("CAR_AMT")));
									
							//등록세
							long tax_amt2 = 0;
							
							if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("")){
								
					      	}else{
					        	if(String.valueOf(ht.get("S_ST")).equals("8") || String.valueOf(ht.get("S_ST")).equals("7")){//화물
					        		if(String.valueOf(ht.get("CAR_ST")).equals("리스") && (String.valueOf(ht.get("S_ST2")).equals("702") || String.valueOf(ht.get("S_ST2")).equals("802"))){
					        			
					        		}else{
					        			tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX3")));
									}
								}else{
									if(String.valueOf(ht.get("CAR_ST")).equals("렌트")){//렌트
										tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX2")));
									}else{//리스
										if(String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409")){
											//경차 리스 50만원 경감
											tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX2")));
										}else{
											tax_amt2 = Long.parseLong(String.valueOf(ht.get("TAX5")));
										}
									}
								}
							}
							
							total_amt2 	= total_amt2 + tax_amt2;
								
							//취득세
							long tax_amt3 = 0;
							
							if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("")){
								if(String.valueOf(ht.get("S_ST")).equals("8") || String.valueOf(ht.get("S_ST")).equals("7")){//화물
									if(String.valueOf(ht.get("CAR_ST")).equals("리스") && (String.valueOf(ht.get("S_ST2")).equals("702") || String.valueOf(ht.get("S_ST2")).equals("802"))){
										
									}else{
										tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX5")));
									}
								}else{
									if(String.valueOf(ht.get("CAR_ST")).equals("렌트")){//렌트
										tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX4")));
									}else{//리스
										if(String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409")){
											//경차 리스 50만원 경감
											tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX4")));
										}else{
											tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX7")));
										}
									}
								}
							}else{
								if(String.valueOf(ht.get("CAR_ST")).equals("리스") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409"))){
									//경차 리스 50만원 경감
									tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX2")));
								}else{
									tax_amt3 = Long.parseLong(String.valueOf(ht.get("TAX2")));
								}
							}
							
							//친환경차 취득세 감면
							if(!String.valueOf(ht.get("JG_G_7")).equals("")){
								if(String.valueOf(ht.get("JG_G_7")).equals("1") || String.valueOf(ht.get("JG_G_7")).equals("2")){
									//if(AddUtil.parseInt(String.valueOf(ht.get("DLV_DT"))) >= 20210101){
										//20210101 하이브리드 취득세 감면혜택 일부 축소 900000->400000
										tax_amt3 = tax_amt3 - 400000;
									//}else{
										//20200101 하이브리드 취득세 감면혜택 일부 축소  1400000->900000
										//tax_amt3 = tax_amt3 - 900000;	
									//}
								}else if(String.valueOf(ht.get("JG_G_7")).equals("3") || String.valueOf(ht.get("JG_G_7")).equals("4")){
									tax_amt3 = tax_amt3 - 1400000;
								}
								if(tax_amt3 < 0)	tax_amt3 = 0;
							}
							//경차 리스 50만원 경감-> 2022년 75만원
							if(String.valueOf(ht.get("CAR_ST")).equals("리스") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409"))){
								if(AddUtil.parseInt(String.valueOf(ht.get("DLV_DT"))) >= 20220101){
									if(tax_amt3<750000){
										tax_amt3 = 0;
									}else{
										tax_amt3 = tax_amt3-750000;
									}
								}else{
									if(tax_amt3<500000){
										tax_amt3 = 0;
									}else{
										tax_amt3 = tax_amt3-500000;
									}
								}
							}
									
							total_amt3 	= total_amt3 + tax_amt3;
						%>
		        <tr>
					<td align='center'><%=i+1%></td>
					<td align='center'><!-- 구분 -->
						      <%if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("")){//X%>
						        <%if(String.valueOf(ht.get("CAR_ST")).equals("업무대여")){%>렌트<%}else{%><%=ht.get("CAR_ST")%><%}%>
						      <%}else{%>
						        금융
						      <%}%>
					</td>
        		  	<td align='center'><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td><!-- 차명 -->
        		  	<td align='center'><%=ht.get("CAR_NUM")%></td><!-- 차대번호 -->
        		  	<td align='center'><%=ht.get("EST_CAR_NO")%></td><!-- 차량번호 -->
        		  	<td align='center'><%=ht.get("TMP_DRV_NO")%></td><!-- 임시번호 -->
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_AMT")))%></td><!-- 공급가액 -->
        			<td align='right'><%=Util.parseDecimal(tax_amt2)%></td><!-- 등록세 -->
					<td align='right'><%=Util.parseDecimal(tax_amt3)%></td><!-- 취득세 -->
        			<td align='center'><!-- 법인명 -->
								<%//if((!String.valueOf(ht.get("JG_G_7")).equals("") && !String.valueOf(ht.get("JG_G_7")).equals("null")) || (String.valueOf(ht.get("CAR_ST")).equals("리스") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409")))){%>
								<%//}else{%>
									<%=ht.get("ACQ_CNG_COM")%>
								<%//}//20220504 차량대금지급처리에서 등록된 내용대로 보이게 함%>
					</td>
        			<td align='center'><%=ht.get("APP_ST")%></td><!-- 등록번호 -->
              		<td align='center'><!-- 주소 -->
              					<%=ht.get("ADDR")%>
								<%-- <%if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("산은캐피탈")){%>
								서울시 영등포구 여의도동 16-2
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("삼성카드")){%>
								서울시 중구 태평로2가 250
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("IBK캐피탈")){%>	
								서울시 강남구 테헤란로 414 (대치동)
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("우리파이낸셜")){%>
								서울시 서초구 서초동 1337-20
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("무림캐피탈")){%>
								서울시 중구 소공동 110 한화빌딩 10층
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("BS캐피탈")){%>
								부산시 부산진구 부전동 259-4 부산은행부전동지점 9층
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("신한캐피탈")){%>
								부산광역시 부산진구 새싹로 6 (부전동)
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("롯데캐피탈")){%>
								서울시 강남구 역삼동 736-1
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("현대캐피탈")){%>
								서울시 영등포구 여의도동 15-21
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("하나캐피탈")){%>
								서울시 강남구 테헤란로 126 (역삼동 대공빌딩13층)
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("DGB캐피탈")){%>
								서울시 강남구 언주로30길 39 (도곡동,삼성엔지니어링사옥18층)
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("메리츠종금증권")){%>
								서울시 영등포구 국제금융로6길 15 (여의도동)
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("한국씨티그룹캐피탈")){%>
								서울시 종로구 창경궁로 120 (인의동, 종로플레이스)
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("KB캐피탈")){%>
								경기도 수원시 팔달구 효원로 295 (인계동)
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("메리츠캐피탈")){%>
								서울시 영등포구 국제금융로2길 11 (여의도동)
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("KT캐피탈")){%>
								서울시 강남구 삼성로 511 (삼성동,골든타워12층)
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("오릭스캐피탈코리아")){%>
								서울시 강남구 테헤란로 317 (역삼동,동훈타워10층)
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("롯데오토리스")){%>	
								경기도 안양시 동안구 전파로 88 (호계동, 신원비젼타워 8층)
								<%}else if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("비엔케이캐피탈")){%>	
								부산시 부산진구 새싹로 1 (부전동, 부산은행 부전동지점 9층)
								<%}else{%>
								<%}%> --%>
					</td>
		        </tr>
						<%}%>
		        <tr>
        			<td align='center' colspan='7'>합계</td>
        			<td align='right' ><%=Util.parseDecimal(total_amt2)%></td>
        			<td align='right' ><%=Util.parseDecimal(total_amt3)%></td>
        			<td colspan='3'>&nbsp;<%=Util.parseDecimal(total_amt2+total_amt3)%>(등록세+취득세)</td>
		        </tr>
		    </table>
	    </td>
    </tr>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>