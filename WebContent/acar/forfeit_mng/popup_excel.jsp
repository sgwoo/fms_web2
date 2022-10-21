<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_forfeit_mng_popup_excel.xls");
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//이의신청
/*	function apply(){
		var fm = document.form1;
		fm.target="i_no";
		fm.action="popup_excel_null.jsp ";
		fm.submit();		
	}*/
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String rent="";
	
	
	AddForfeitDatabase afm_db = AddForfeitDatabase.getInstance();
%>
<form action="" name="form1" method="POST" >
<table border="0" cellspacing="0" cellpadding="0" width='695'>
  <tr> 
    <td colspan="7" height="40" align="center"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="6">amazonCAR.co.kr</font></b></td>
  </tr>
  <tr> 
    <td width='91' height="5" align="center">&nbsp;</td>
    <td width='65' height="5" align="center">&nbsp;</td>
    <td width='82' height="5" align="center">&nbsp;</td>
    <td width='73' height="5" align="center">&nbsp;</td>
    <td width='147' height="5" align="center">&nbsp;</td>
    <td width="158" height="5" align="center">&nbsp;</td>
    <td width="79" height="5" align="center">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="7" align='center' height="20"><font size="2" face="새굴림">우150-874 
      서울특별시 영등포구 여의도동 17-3 삼환까뮤빌딩 602 전화:02)392-4242 FAX:02)757-0803 </font></td>
  </tr>
  <tr> 
    <td colspan="7" align='center' height="20"><font size="2" face="새굴림">담당 이미안 
      yuyu0@amazonCAR.co.kr</font></td>
  </tr>
  <tr bgcolor="#999999"> 
    <td colspan=7 align='center' height="10"></td>
  </tr>
  <tr bgcolor="#FFFFFF"> 
    <td colspan=7 align='center' height="5"></td>
  </tr>
  <tr> 
    <td align='center' height="30"><font size="2" face="새굴림">문서번호</font></td>
    <td colspan=3 height="30"><font size="2" face="새굴림">관리 <%=AddUtil.getDate(1)+AddUtil.getDate(2)%>-00</font></td>
    <td align='center' height="30"><font size="2" face="새굴림"></font></td>
    <td align='center' height="30"><font size="2" face="새굴림"></font></td>
    <td align='center' height="30"><font size="2" face="새굴림"></font></td>
  </tr>
  <tr> 
    <td align='center' height="30"><font size="2" face="새굴림">발신일자</font></td>
    <td colspan=3 height="30"><font size="2" face="새굴림">'<%=AddUtil.getDate3()%></font></td>
    <td align='center' height="30"><font size="2" face="새굴림"></font></td>
    <td align='center' height="30"><font size="2" face="새굴림"></font></td>
    <td align='center' height="30"><font size="2" face="새굴림"></font></td>
  </tr>
  <tr> 
    <td align='center' height="30"><font size="2" face="새굴림">수&nbsp;&nbsp;&nbsp;&nbsp;신</font></td>
    <td colspan=3 height="30"><font size="2" face="새굴림"><%=t_wd%></font></td>
    <td align='center' height="30"><font size="2" face="새굴림"></font></td>
    <td align='center' height="30"><font size="2" face="새굴림"></font></td>
    <td align='center' height="30"><font size="2" face="새굴림"></font></td>
  </tr>
  <tr> 
    <td align='center' height="30"><font size="2" face="새굴림">참&nbsp;&nbsp;&nbsp;&nbsp;조</font></td>
    <td colspan=3 height="30"><font size="2" face="새굴림">교통과</font></td>
    <td align='center' height="30"><font size="2" face="새굴림"></font></td>
    <td align='center' height="30"><font size="2" face="새굴림"></font></td>
    <td align='center' height="30"><font size="2" face="새굴림"></font></td>
  </tr>
  <tr> 
    <td align='center' height="30"><font size="2" face="새굴림">제&nbsp;&nbsp;&nbsp;&nbsp;목</font></td>
    <td colspan=6 height="30"><font size="2" face="새굴림">과태료부과 이의신청(대여사업차량에 대한 
      과태료 납부 의무자 변경 요청)</font></td>
  </tr>
  <tr bgcolor="#FFFFFF"> 
    <td colspan=7 align='center' height="5"></td>
  </tr>
  <tr bgcolor="#999999"> 
    <td colspan=7 align='center' height="10"></td>
  </tr>
  <tr> 
    <td colspan=7 align='center'>&nbsp;</td>
  </tr>
  <tr> 
    <td align='center' height="30"><font size="2" face="새굴림"></font></td>
    <td colspan=6 height="30"><font size="2" face="새굴림">1. 귀 경찰서의 일익 번창하심을 기원합니다.</font></td>
  </tr>
  <tr> 
    <td align='center' height="30"><font size="2" face="새굴림"></font></td>
    <td colspan=6 height="30"><font size="2" face="새굴림">2. 당사(자동차대여사업자)에 부과한 과태료는 
      위반당시 임차중이었음으로 납부의무를 당사 고객인 </font></td>
  </tr>
  <tr> 
    <td height="30" colspan="7"><font size="2" face="새굴림">아래 임차인에게 변경 부과 바랍니다.</font></td>
  </tr>
  <tr> 
    <td colspan=7 align='center' height="30">&nbsp;</td>
  </tr>
</table>
<table border="1" cellspacing="0" cellpadding="0" width='695' bordercolor="#000000">
  <tr bgcolor="#A6FFFF" valign="middle"> 
    <td width='91' height="37" align="center"><font size="2" face="새굴림">고지서번호</font></td>
    <td width='65' height="37" align="center"><font size="2" face="새굴림">차량번호</font></td>
    <td width='82' height="37" align="center"><font size="2" face="새굴림">위반일시</font></td>
    <td width='80' height="37" align="center"><font size="2" face="새굴림">차량소유자</font></td>
    <td width='140' height="37" align="center"><font size="2" face="새굴림">임차인</font></td>
    <td width="158" height="37" align="center"><font size="2" face="새굴림">임차인주소</font></td>
    <td width="79" height="37" align="center"><font size="2" face="새굴림">임대기간</font></td>
  </tr>
  <%	//선택리스트
	String vid[] = request.getParameterValues("ch_l_cd");
	String vid_num="";
	String ch_m_id="";
	String ch_l_cd="";
	String ch_c_id="";
	String ch_seq_no="";
	for(int i=0;i < vid.length;i++){
		vid_num=vid[i];
		ch_m_id = vid_num.substring(0,6);
		ch_l_cd = vid_num.substring(6,19);
		ch_c_id = vid_num.substring(19,25);
		ch_seq_no = vid_num.substring(25);
		Hashtable fine = afm_db.getFineExpListExcel(ch_m_id, ch_l_cd, ch_c_id, ch_seq_no);
		String paid_no = (String)fine.get("PAID_NO");		
		String car_no = (String)fine.get("CAR_NO");		
		String vio_dt = (String)fine.get("VIO_DT");		
		String addr = (String)fine.get("O_ADDR");				
%>
<input type="hidden" name="v_id" value="<%=vid_num%>">
  <tr> 
    <td width='91' align='center' height="53"><font size="2" face="새굴림">
	<%out.println(paid_no);%></font></td>
    <td width='65' align='center' height="53"><font size="2" face="새굴림"><%=car_no%></font></td>
    <td width='82' align='center' height="53"><font size="2" face="새굴림"><%=vio_dt%></font></td>
    <td width='80' align='center' height="53"><font size="2" face="새굴림">(주)아마존카</font></td>
    <td width='140' align='center' height="53"><font size="2" face="새굴림"><%=fine.get("FIRM_NM")%>&nbsp;
      <%=fine.get("SSN")%>&nbsp;
      <%=fine.get("ENP_NO")%></font></td>
    <td width="158" height="53"><font size="2" face="새굴림"> 
      <%out.println(addr);%>
      </font></td>
    <td align='center' width="79" height="53"><font size="2" face="새굴림"><%=fine.get("RENT_START_DT")%>~
      <%=fine.get("RENT_END_DT")%></font></td>
  </tr>
  <%	}%>
</table>
<table border="0" cellspacing="0" cellpadding="0" width='695'>
  <tr> 
    <td width='91' height="20" align="center">&nbsp;</td>
    <td width='65' height="20" align="center">&nbsp;</td>
    <td width='82' height="20" align="center">&nbsp;</td>
    <td width='73' height="20" align="center">&nbsp;</td>
    <td width='147' height="20" align="center">&nbsp;</td>
    <td width="158" height="20" align="center">&nbsp;</td>
    <td width="79" height="20" align="center">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="7" height="20" align="center">&nbsp;</td>
  </tr>
  <tr> 
    <td width='91' height="20" align="center">&nbsp;</td>
    <td width='65' height="20" align="center">&nbsp;</td>
    <td width='82' height="20" align="center">&nbsp;</td>
    <td width='73' height="20" align="center">&nbsp;</td>
    <td width='147' height="20" align="center">&nbsp;</td>
    <td width="158" height="20" align="center">&nbsp;</td>
    <td width="79" height="20" align="center">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="7" align='center' height="30"><font size="5"><b><font face="새굴림">주식회사 
      아마존카 대표이사 조&nbsp;&nbsp;성&nbsp;&nbsp;희</font></b></font></td>
  </tr>
</table>
</form>
</body>
</html>
