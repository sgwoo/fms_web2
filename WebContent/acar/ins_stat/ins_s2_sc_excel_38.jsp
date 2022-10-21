<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_ins_s2_sc_excel_38.xls");
%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"3":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String mod_st = request.getParameter("mod_st")==null?"":request.getParameter("mod_st");
	
	if(!st_dt.equals("")) st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) end_dt = AddUtil.replace(end_dt, "-", "");
	
	
	InsEtcDatabase ie_db = InsEtcDatabase.getInstance();
	
	Vector inss = ie_db.getInsStatList1_excel(br_id, gubun1, gubun2, gubun3, gubun4, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st, mod_st);
	int ins_size = inss.size();
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<table border="0" cellspacing="0" cellpadding="0" width='2680'>
    <tr>
        <td height="40" align="center" style="font-size : 20pt;"><b>공제조합신청서</b></td>
    </tr>
    <tr>
        <td align='right'>총건수 : <%=ins_size%>건</td>
    </tr>    
    <tr>
	<td height="25" style="font-size : 12pt;">귀사와 체결한 모든 자동차 보험 청약서에 자필서명(직인날인)을 하여야 하나 부득이한 사유로 인하여 하기건에 대해서는 본확인서로 대체하고자합니다.</td>
    </tr>    
    <tr> 
      <td height="10" align='center'></td>
    </tr>    
    <tr>
	<td height="25" style="font-size : 12pt;">귀사와 체결한 자동차 보험 청약서 상의 모든 조건을 인정하며 특히 하기 조건에 대하여 다시한번 확인하며 어떠한 이의도 제기하지 않을 것을 확인합니다.</td>
    </tr>    
    <tr>
	<td>&nbsp;</td>
    </tr>           
    <tr>
	<td align='right' height="50" style="font-size : 15pt;">
	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
	        <tr>
	            <td width='860' >&nbsp;</td>
	            <td width='100' valign="top" >피공제자 : </td>
	            <td width='300' >서울시 영등포구 의사당대로 8,<br>
	                             802호 (여의도동, 태흥빌딩 802호)<br><br>
	                             <span class=style6>(주)아마존카 대표이사 &nbsp;&nbsp;&nbsp;&nbsp;조 &nbsp;&nbsp;&nbsp;&nbsp;성 &nbsp;&nbsp;&nbsp;&nbsp;희
	            </td>
	            <td width='80' ><img src="/acar/images/stamp.png" width="75" height="75"></td>
	        </tr>
	    </table>
	</td>
    </tr>           
    <tr>
	<td>&nbsp;</td>
    </tr>                
    <tr> 
        <td > 
     		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr class=title> 
                    
                    <td width='50' class='title'>연번</td>				
                    <td width='100' class='title'>전보험사</td>
                    <td width='100' class='title'>가입보험사</td>
                    <td width='100' class='title'>시작일</td>
                    <td width='100' class='title'>차량번호</td>
                    <td width='150' class='title'>차대번호</td>					
                    <td width='150' class='title'>차명</td>
                    <td width='100' class='title'>차종</td>					
                    <td width='50' class='title'>승차<br>정원</td>					
                    <td width='100' class='title'>최초등록일</td>										
                    <td width='50' class='title'>에어백</td>
                    <td width='50' class='title'>자동<br>변속기</td>
                    <td width='50' class='title'>ABS<br>장치</td>					
                    <td width='50' class='title'>블랙<br>박스</td>			
                    <td width='50' class='title'>연령</td>
                    <td width='70' class='title'>대물</td>						
                    <td width='70' class='title'>자기신체<br>사망</td>						
                    <td width='70' class='title'>자기신체<br>부상</td>						
                    <td width='70' class='title'>자차</td>						
                    <td width='70' class='title'>무보험</td>						
                    <td width='70' class='title'>긴출</td>	
                    <td width='100' class='title'>임직원전용자동차보험</td>											
                    <td width='130' class='title'>증권번호</td>						
                    <td width='150' class='title'>장기거래처</td>
                    <td width='150' class='title'>관리담당자</td>
                    <td width='150' class='title'>사업자번호</td>
                    <td width='150' class='title'>대여기간</td>
                    <td class='title' width='100' >블랙박스</td>
                    <td class='title' width='80' >가격(공급가)</td>
                    <td class='title' width='100'>시리얼번호</td>			
                </tr>			
              <% 		for (int i = 0 ; i < ins_size ; i++){
    									Hashtable ins = (Hashtable)inss.elementAt(i);
    									
    									//해지 결재진행분은 아마존카로 한다.
    									if(!(ins.get("DOC_NO")+"").equals("") && !(ins.get("FIRM_NM")+"").equals("(주)아마존카")){
    										ins.put("FIRM_NM", "(주)아마존카");
    										ins.put("ENP_NO", "1288147957");
    										ins.put("AGE_SCP", "26세이상");
    										ins.put("VINS_GCP_KD", "1억원");
    										ins.put("VINS_BACDT_KD", "1억원");
    										ins.put("COM_EMP_YN", "N");
    									}
    									%>
                <tr> 
                    
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=i+1%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("INS_COM_NM")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'>&nbsp;</td>														
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("CAR_NO")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("CAR_NUM")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("CAR_NM")%> <%=ins.get("CAR_NAME")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("CAR_KD")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("TAKING_P")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INIT_REG_DT")))%></td>										
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("AIR")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("AUTO")%></td>										
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("ABS")%></td>															
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'>
                    	<%if(String.valueOf(ins.get("BLACKBOX")).equals("0") && AddUtil.parseInt(String.valueOf(ins.get("B_AMT")))>0){%>
                    	1
                    	<%}else{%>
                    	<%=ins.get("BLACKBOX")%>
                    	<%}%>
                    </td>		
                    													
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("AGE_SCP")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_GCP_KD")%></td>										
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_BACDT_KD")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_BACDT_KC2")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_CACDT2")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_CANOISR2")%><!--N--></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_SPE2")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("COM_EMP_YN")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'>&nbsp;</td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'  <%if((ins.get("FIRM_EMP_NM")+"").equals("")){%>style="color:green;"<%}else if(!(ins.get("FIRM_EMP_NM")+"").equals((ins.get("FIRM_NM")+""))){%>style="color:red;"<%}%>  ><%=ins.get("FIRM_NM")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("USER_NM")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("ENP_NO")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("RENT_START_DT")%>~<%=ins.get("RENT_END_DT")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("B_COM_NM")%>-<%=ins.get("B_MODEL_NM")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='right'>
                    	<%if(String.valueOf(ins.get("B_COM_NM")).equals("이노픽스") && (String.valueOf(ins.get("B_MODEL_NM")).equals("LX100") || String.valueOf(ins.get("B_MODEL_NM")).equals("IX200") || String.valueOf(ins.get("B_MODEL_NM")).equals("IX-200")) && AddUtil.parseDecimal(String.valueOf(ins.get("B_AMT"))).equals("0")){%>
                    	92,727
                    	<%}else{%>
                    	<%=AddUtil.parseDecimal(String.valueOf(ins.get("B_AMT")))%>
                    	<%}%>
                    </td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("B_SERIAL_NO")%></td>										
                </tr>
              <%		}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
