<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
		//대출신청리스트
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function pagesetPrint(){
		IEPageSetupX.header='';
		IEPageSetupX.footer='';
		IEPageSetupX.leftMargin=12;
		IEPageSetupX.rightMargin=12;
		IEPageSetupX.topMargin=20;
		IEPageSetupX.bottomMargin=30;	

	}
	
function IE_Print() {
	factory1.printing.header = ""; //폐이지상단 인쇄
	factory1.printing.footer = ""; //폐이지하단 인쇄
	factory1.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
// 	factory1.printing.leftMargin = 10.0; //좌측여백   
// 	factory1.printing.rightMargin = 10.0; //우측여백
// 	factory1.printing.topMargin = 0.0; //상단여백    
// 	factory1.printing.bottomMargin = 0.0; //하단여백
	factory1.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}

function onprint(){
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		IE_Print();
	}
}
//-->
</script>
</head>
<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()" font face="바탕">
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form action="" name="form1" method="POST" >
  <table width='1650' border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="100%" height="30" align="left" style="font-size : 10pt;"><font face="바탕"># 차량관리번호 내역서</font></td>
    </tr>
    <tr> 
      <td height="10" align="center"></td>
    </tr>	
    <tr bgcolor="#000000"> 
      <td align='center'> 
	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr  bgcolor="#000000"> 
            <td> 
			  <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr bgcolor="#FFFFFF" align="center">
                  <td width="5%" height="25" style="font-size : 8pt;"><font face="바탕">관리번호</font></td>
                  <td width="6%" height="25" style="font-size : 8pt;"><font face="바탕">계약번호</font></td>
                  <td width="6%" height="25" style="font-size : 8pt;"><font face="바탕">차종</font></td>
                  <td width="8%" height="25" style="font-size : 8pt;"><font face="바탕">차명</font></td>
                  <td width="7%" height="25" style="font-size : 8pt;"><font face="바탕">계출번호</font></td>
                  <td width="4%" height="25" style="font-size : 8pt;"><font face="바탕">차량번호</font></td>
                  <td width="4%" height="25" style="font-size : 8pt;"><font face="바탕">등록지역</font></td>
                  <td width="9%" height="25" style="font-size : 8pt;"><font face="바탕">차대번호</font></td>
                  <td width="7%" height="25" style="font-size : 8pt;"><font face="바탕">색상</font></td>
                  <td width="5%" height="25" style="font-size : 8pt;"><font face="바탕">소비자가격 </font></td>
                  <td width="5%" height="25" style="font-size : 8pt;"><font face="바탕">탁송료 </font></td>
                  <td width="5%" height="25" style="font-size : 8pt;"><font face="바탕">취득세발급처</font></td>                                 
	              <td width="5%" height="25" style="font-size : 8pt;"><font face="바탕">계약일자</font></td>
	              <td width="14%" height="25" style="font-size : 8pt;"><font face="바탕">우편물주소</font></td>
	             <td width="14%" height="25" style="font-size : 8pt;"><font face="바탕">옵션</font></td>
                </tr>
                        
              </table></td>
          </tr>
        </table></td>
    </tr>
   <!--  <tr> 
      <td height="2" align="center"></td>
    </tr>	 -->
    <tr bgcolor="#000000">
     <td width="100%" height="10" align='center'><table width="100%" border="0" cellspacing="1" cellpadding="0">
       <% if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					Hashtable ht = (Hashtable)FineList.elementAt(i);				
					
		%>
          <tr bgcolor="#FFFFFF" align="center">
            <td  width="5%" height="20" style="font-size : 8pt;"><font face="바탕"><%=ht.get("CAR_DOC_NO")%></font></td>
            <td  width="6%" height="20" style="font-size : 8pt;"><font face="바탕"><%=ht.get("RENT_L_CD")%></font></td>
            <td  width="6%" height="20" style="font-size : 8pt;"><font face="바탕"><%=ht.get("CAR_NM")%></font></td>            
            <td  width="8%" height="20" style="font-size : 8pt;"><font face="바탕"><%=ht.get("CAR_NAME")%></font></td>
            <td  width="7%" height="20" style="font-size : 8pt;"><font face="바탕"><%=ht.get("RPT_NO")%></font></td>
            <td  width="4%" height="20" style="font-size : 8pt;"><font face="바탕"><%=ht.get("CAR_NO")%></font></td>
            <td  width="4%" height="20" style="font-size : 8pt;"><font face="바탕"><%=c_db.getNameByIdCode("0032", "", String.valueOf(ht.get("CAR_EXT")))%></font></td>
            <td  width="9%" height="20" style="font-size : 8pt;"><font face="바탕"><%=ht.get("CAR_NUM")%></font></td>
            <td  width="7%" height="20" style="font-size : 8pt;"><font face="바탕"><%=ht.get("COLO")%></font></td>
            <td  width="5%" height="20" style="font-size : 8pt;"><font face="바탕"><%=Util.parseDecimal(ht.get("CAR_F_AMT"))%></font></td>
            <td  width="5%" height="20" style="font-size : 8pt;"><font face="바탕"><%=Util.parseDecimal(ht.get("SD_AMT"))%></font></td>
            <td  width="5%" height="20" style="font-size : 8pt;"><font face="바탕"><%=ht.get("ACQ_IS_O")%></font></td>
			<td  width="5%" height="20" style="font-size : 8pt;"><font face="바탕"><%=ht.get("RENT_DT")%></font></td>
			<td  width="14%" height="20" style="font-size : 8pt;"><font face="바탕">(<%=ht.get("O_ZIP")%>) <%=ht.get("O_ADDR")%></font></td>
			<td  width="14%" height="20" style="font-size : 8pt;"><font face="바탕"><%=ht.get("OPT")%></font></td>
          </tr>
         <%} %>    
		<%} %>
      </table></td>
    </tr>
    <tr> 
      <td height="5" align="center"></td>
    </tr>	
  
  </table>
 
</form>
</body>
</html>
