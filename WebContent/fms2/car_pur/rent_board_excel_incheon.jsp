<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=rent_board_excel_incheon.xls");
%>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	
	
	//인천지점
	Hashtable br = c_db.getBranch("I1");
	
	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<!--<link rel=stylesheet type="text/css" href="/include/table_t.css">-->
<body>
<% int col_cnt = 29;%>
<table border="0" cellspacing="0" cellpadding="0" width=1870>
    <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">(주)아마존카 자동차 신규등록 신청 리스트 (<%=AddUtil.getDate()%>)</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
</table>	
<table border="1" cellspacing="0" cellpadding="0" width=1870>
	<!--
    <tr>
        <td class='line'>
	        <table border="1" cellspacing="1" cellpadding="0" width='100%'>
			-->
		        <tr>
        			<td colspan="13" align='center' style="font-size : 15pt;" height="40">제원정보 입력 </td>				  				  
        			<td colspan="9" align='center' style="font-size : 15pt;">대행사 입력 </td>
					<td colspan="7" align='center' style="font-size : 15pt;">기타입력</td>				  
       			</tr>
		        <tr>
                  <td colspan="2"  align='center' style="font-size : 8pt;" height="30">구분</td>				
                  <td colspan="3"  align='center' style="font-size : 8pt;">소유자정보</td>
                  <td colspan="6" align='center' style="font-size : 8pt;">제작증정보</td>
                  <td colspan="2" align='center' style="font-size : 8pt;">수입차정보</td>
                  <td align='center' style="font-size : 8pt;">보험</td>
	              <td align='center' style="font-size : 8pt;">채권</td>
	              <td colspan="3" align='center' style="font-size : 8pt;">특이사항</td>
                  <td colspan="4" align='center' style="font-size : 8pt;">공동소유</td>
                  <td align='center' style="font-size : 8pt;">차량번호</td>
	              <td colspan="3" align='center' style="font-size : 8pt;">취득자정보(금융)</td>
                  <td colspan="2" align='center' style="font-size : 8pt;">배출가스 및 소음인증</td>
                  <td rowspan='2' align='center' style="font-size : 8pt;">배송지역</td>
              </tr>
		        <tr>
		          <td width='30' align='center' style="font-size : 8pt;">연번</td>
		          <td width='30' align='center' style="font-size : 8pt;">구분</td>
		          <td width='70' align='center' style="font-size : 8pt;">소유자명</td>
	              <td width='60' align='center' style="font-size : 8pt;">법인번호</td>
	              <td width='150' align='center' style="font-size : 8pt;">사용본거지</td>
	              <td width='50' align='center' style="font-size : 8pt;">제작증발행일</td>
	              <td width='100' align='center' style="font-size : 8pt;">차명</td>
	              <td width='50' align='center' style="font-size : 8pt;">원동기형식</td>
	              <td width='100' align='center' style="font-size : 8pt;">차대번호</td>
	              <td width='60' align='center' style="font-size : 8pt;">제원관리번호</td>
	              <td width='80' align='center' style="font-size : 8pt;">공급가액</td>
	              <td width='60' align='center' style="font-size : 8pt;">수입신고번호</td>
	              <td width='60' align='center' style="font-size : 8pt;">수입신고일</td>
	              <td width='60' align='center' style="font-size : 8pt;">계약번호</td>
	              <td width='60' align='center' style="font-size : 8pt;">채권할인</td>
	              <td width='50' align='center' style="font-size : 8pt;">감면</td>
	              <td width='60' align='center' style="font-size : 8pt;">임판번호</td>
	              <td width='60' align='center' style="font-size : 8pt;">번호판특이사항</td>
	              <td width='50' align='center' style="font-size : 8pt;">공동소유자</td>
	              <td width='50' align='center' style="font-size : 8pt;">주민번호</td>
	              <td width='50' align='center' style="font-size : 8pt;">주소</td>
	              <td width='50' align='center' style="font-size : 8pt;">지분율</td>
	              <td width='80' align='center' style="font-size : 8pt;">렌터카부여번호</td>
	              <td width='70' align='center' style="font-size : 8pt;">취득자명</td>
	              <td width='60' align='center' style="font-size : 8pt;">법인번호</td>
	              <td width='150' align='center' style="font-size : 8pt;">주소</td>
	              <td width='60' align='center' style="font-size : 8pt;">자동차배출가스인증번호</td>
	              <td width='60' align='center' style="font-size : 8pt;">자동차소음인증번호</td>
	          </tr>		
		  		<%	for(int i=0;i < vid_size;i++){
						rent_l_cd = vid[i];
						Hashtable ht = a_db.getRentBoardSubCase(rent_l_cd);						
						total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("CAR_AMT")));
						
						String tax_exempt = "";						
						//친환경차 취득세 감면
						if(!String.valueOf(ht.get("JG_G_7")).equals("")){
							if(String.valueOf(ht.get("JG_G_7")).equals("1") || String.valueOf(ht.get("JG_G_7")).equals("2")){
								tax_exempt = "감면";
							}else if(String.valueOf(ht.get("JG_G_7")).equals("3") || String.valueOf(ht.get("JG_G_7")).equals("4")){
								tax_exempt = "감면";
							}							
						}
				%>
		        <tr>
        			<td align='center' style="font-size : 8pt;"><%=i+1%></td>
        		    <td align='center' style="font-size : 8pt;">
					<%if(String.valueOf(ht.get("ACQ_CNG_COM")).equals("")){//X%>
					<%if(String.valueOf(ht.get("CAR_ST")).equals("업무대여")){%>렌트<%}else{%><%=ht.get("CAR_ST")%><%}%>
					<%}else{%>
					금융
					<%}%>
					</td>
        		    <td align='center' style="font-size : 8pt;">(주)아마존카</td>
        		    <td align='center' style="font-size : 8pt;">115611-0019610</td>
        		    <td align='center' style="font-size : 8pt;"><%=br.get("BR_ADDR")%></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;">
        		        <%if(!tax_exempt.equals("")){ %><span style="color:blue; letter-spacing: -1px;font-weight:bold;"><b>[감면]</b></span><%}%>
        		   		<%if(ht.get("JG_G_16").equals("1")){ %><span style="color:red; letter-spacing: -1px;font-weight:bold;">[저공해]</span><%}%>
						<%if(ht.get("JG_G_7").equals("3")){ %><span style="color:darkorange; letter-spacing: -1px;">[전]</span><%}%>
						<%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%>
						<%-- <%if(String.valueOf(ht.get("DIESEL_YN")).equals("3") || String.valueOf(ht.get("DIESEL_YN")).equals("4") || String.valueOf(ht.get("DIESEL_YN")).equals("5")){%>
        		    	<font color=red><b>[저공해]<%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></b></font> --%>
        		    <%-- 	<%}else{%>
        		    	<%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%>
        		    	<%}% --%>
        		    </td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NUM")%></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        			<td align='right' style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CAR_AMT")))%></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"><%=ht.get("TMP_DRV_NO")%><%if(String.valueOf(ht.get("TMP_DRV_NO")).equals("")){%>임시운행미발급<%}%></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>																				
        		    <td align='center' style="font-size : 8pt;">
        		    <%if(String.valueOf(ht.get("NEW_LICENSE_PLATE")).equals("1") || String.valueOf(ht.get("NEW_LICENSE_PLATE")).equals("2")){%>
							<!--<span style="color:red; letter-spacing: -1px;">[신형]</span>-->
					<%}else{%>
					        <span style="color:red; letter-spacing: -1px;">(구)</span>
					<%}%>         		    
        		    <%=ht.get("EST_CAR_NO")%></td>
        			<td align='center' style="font-size : 8pt;">
					<%//		if((!String.valueOf(ht.get("JG_G_7")).equals("") && !String.valueOf(ht.get("JG_G_7")).equals("null")) || (String.valueOf(ht.get("CAR_ST")).equals("리스") && (String.valueOf(ht.get("S_ST2")).equals("100") || String.valueOf(ht.get("S_ST2")).equals("101") || String.valueOf(ht.get("S_ST2")).equals("409") || String.valueOf(ht.get("S_ST2")).equals("702") || String.valueOf(ht.get("S_ST2")).equals("802")))){%>
					<%//		}else{%>
					<%=ht.get("ACQ_CNG_COM")%>
					<%//		} //20220504 차량대금지급처리에서 등록된 내용대로 보이게 함%>
					</td>
        			<td align='center' style="font-size : 8pt;"><%=ht.get("APP_ST")%></td>	
               		<td align='center' style="font-size : 8pt;">
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
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;"></td>
        		    <td align='center' style="font-size : 8pt;">
        		    <%if(String.valueOf(ht.get("JG_G_7")).equals("3") || String.valueOf(ht.get("CAR_ST")).equals("리스")){%>
        		    <%}else{%>
        		    <%	if(String.valueOf(ht.get("UDT_ST")).equals("2")){%>
        		    부산
        		    <%	}else if(String.valueOf(ht.get("UDT_ST")).equals("3")){%>
        		    대전
        		    <%	}else if(String.valueOf(ht.get("UDT_ST")).equals("5")){%>
        		    대구
        		    <%	}%>
        		    <%}%>        		    
        		    </td>
		        </tr>
				<%	}%>
<!--				
		    </table>
	    </td>
    </tr>  		    		  
	-->
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

