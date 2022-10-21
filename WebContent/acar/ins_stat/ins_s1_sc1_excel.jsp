<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
String sFileName = "보험가입현황_신규등록현황" + ".xls";
sFileName = new String ( sFileName.getBytes("KSC5601"), "8859_1");
String fileName = sFileName;
//최종 파일 다운로드 
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition", "attachment; filename=" + fileName + ";");

%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr"><!--엑셀로 export시 한글깨짐 현상 방지-->
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	int size1 = 0;
	
	if(!st_dt.equals("")) 	st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) 	end_dt = AddUtil.replace(end_dt, "-", "");
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector inss = ai_db.getInsStatList_in1(br_id, brch_id, st_dt, end_dt, gubun1, gubun2);
	int ins_size = inss.size();	
	
	long total_amt = 0;
%>
<!--
<p>* 인쇄를 하실려면 먼저 상단메뉴에서 파일>페이지설정를 선택 -> 페이지에서 용지방향 가로에 체크하고 인쇄하십시오. </p>
<P>※ 하단의 각셀의 형식 및 위치는 삭제 및 변경할 수 없습니다. (고정셀)</P>
<P>규칙1 - 사원번호는 8자리까지 가능(영문자 또는 숫자, 특수문자는 - 가능)</P>
<P>규칙2 - 근태항목에 대한 입력 포맷은 XINSA 인사급여시스템에서 정한 규칙으로 입력해야 합니다. (즉, 시간단위로 입력하는 경우는 시간으로 입력)</P>
-->
<table border="0" cellspacing="0" cellpadding="0" width=1920 bordercolor="#000000">
    <tr> 
        <td class=> 
            <table border="1" cellspacing="1" cellpadding="0" width='100%' bordercolor="#000000">
                <tr> 
                    <td class='title' width='50'>연번</td>
                    <td class='title' width="70">차량구분</td>
                    <td class='title' width="200">고객명</td>
                    <td class='title' width="100">사업자번호</td>
                    <!--<td class='title' width="180">계약기간</td>-->
                    <td class='title' width="100">차량번호</td>
                    <td class='title' width="150">차대번호</td>
                    <td class='title' width="100">차종코드</td>
                    <td class='title' width="150">차종</td>
                    <td class='title' width="80">최초등록일</td>
                    <td class='title' width="70">등록사유</td>
                    <td class='title' width="70">보험구분</td>
                    <td class='title' width="100">보험회사</td>
                    <td class='title' width="100">증권번호</td>
                    <td class='title' width="180">보험기간</td>
                    <td class='title' width="100">보험료</td>
                    <td class='title' width="200">블랙박스</td>
                    <td class='title' width="100">시리얼번호</td>
                    <td class='title' width="100">블랙박스금액</td>
                </tr>
              <%if(ins_size > 0){%>
              <%	for (int i = 0 ; i < ins_size ; i++){
    								Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ins.get("CAR_ST")%></td>
                    <td align="center"><%=ins.get("FIRM_NM")%></td>
                    <td align="center"><%=ins.get("ENP_NO")%></td>
                    <!--<td align="center"><%=ins.get("RENT_START_DT")%>~<%=ins.get("RENT_END_DT")%></td>-->
                    <td align="center"><%=ins.get("CAR_NO")%></td>
                    <td align="center"><%=ins.get("CAR_NUM")%></td>
                    <td align="center"><%=ins.get("JG_CODE")%></td>
                    <td align="center"><span title='<%=ins.get("CAR_NM")%> <%=ins.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(ins.get("CAR_NM")), 9)%></span></td>
                    <td align="center"><%=ins.get("INIT_REG_DT")%></td>
                    <td align="center"><%=ins.get("REG_CAU")%></td>
                    <td align="center"><%=ins.get("INS_KD")%></td>
                    <td align="center"><%=ins.get("INS_COM_NM")%></td>
                    <td align="center"><%=ins.get("INS_CON_NO")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></td>
                    <td align=right><%=Util.parseDecimal(String.valueOf(ins.get("INS_AMT")))%></td>
                    <td align=center><%=ins.get("B_COM_NM")%>-<%=ins.get("B_MODEL_NM")%></td>
                    <td align=center><%=ins.get("B_SERIAL_NO")%></td>
                    <td align=right>
                    	<%if(!String.valueOf(ins.get("B_MODEL_NM")).equals("") && AddUtil.parseDecimal(String.valueOf(ins.get("B_AMT"))).equals("0")){%>
                      92,727
                      <%}else{%>
                      <%=AddUtil.parseDecimal(String.valueOf(ins.get("B_AMT")))%>
                      <%}%>
                    </td>
                </tr>
              <%		total_amt = total_amt + Long.parseLong(String.valueOf(ins.get("INS_AMT")));
    			  		}%>
                <tr> 
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>계</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                    <td class='title'>&nbsp;</td>
                </tr>
              <%}else{%>
                <tr align="center"> 
                    <td colspan="17">등록된 데이타가 없습니다.</td>
                </tr>
              <%}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
