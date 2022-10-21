<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
		
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");

	String reg_code 	= request.getParameter("code")==null?"":request.getParameter("code");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	
	
	InsurExcelBean iec_bean = ic_db.getInsExcelCom(reg_code, seq);
	
	Hashtable ht = ic_db.getInsExcelComCase(reg_code, seq);
	
	int b_size = 33;
	
	if(iec_bean.getGubun().equals("갱신")) b_size = 49;
	if(iec_bean.getGubun().equals("배서")) b_size = 38;
	
	String value_nm[]	 = new String[b_size+1];
	
	
	if(iec_bean.getGubun().equals("가입")){
		value_nm[1]  = "고객";
		value_nm[33]  = "상호(보험사용)";
		value_nm[2]  = "사업자등록번호";
		value_nm[3]  = "차명";
		value_nm[4]  = "차량번호";
		value_nm[5]  = "차대번호";
		value_nm[6]  = "차량소비자가";
		value_nm[7]  = "운전자연령";
		value_nm[8]  = "대물배상";
		value_nm[9]  = "자기신체사고";
		value_nm[10] = "임직원전용";
		value_nm[11] = "블랙박스";
		value_nm[12] = "가격(공급가)";
		value_nm[13] = "시리얼번호";
		value_nm[14] = "보험사코드";
	}
	
	if(iec_bean.getGubun().equals("갱신")){
		value_nm[1]  = "전보험사";
		value_nm[2]  = "가입보험사";
		value_nm[3]  = "시작일";
		value_nm[4]  = "차량번호";
		value_nm[5]  = "차대번호";
		value_nm[6]  = "차명";
		value_nm[7]  = "차종";
		value_nm[8]  = "승차정원";
		value_nm[9]  = "최초등록일";
		value_nm[10] = "에어백";
		value_nm[11] = "자동변속기";
		value_nm[12] = "ABS장치";
		value_nm[13] = "블랙박스";
		value_nm[14] = "연령";
		value_nm[15] = "대물";
		value_nm[16] = "자기신체사망";
		value_nm[17] = "자기신체부상";
		value_nm[18] = "자차";
		value_nm[19] = "무보험";
		value_nm[20] = "긴출";
		value_nm[21] = "임직원전용";
		value_nm[22] = "증권번호";
		value_nm[23] = "장기거래처";
		value_nm[24] = "관리담당자";
		value_nm[25] = "사업자번호";
		value_nm[26] = "대여기간";
		value_nm[27] = "블랙박스";
		value_nm[28] = "가격(공급가)";
		value_nm[29] = "시리얼번호";
		value_nm[30] = "보험사코드";
		value_nm[49] = "상호(보험사용)";
	}	
	
	if(iec_bean.getGubun().equals("배서")){
		value_nm[1]  = "차량번호";
		value_nm[2]  = "증권번호";
		value_nm[3]  = "고객";
		value_nm[4]  = "차명";
		value_nm[5]  = "사업자번호";
		value_nm[6]  = "보험시작일";
		value_nm[7]  = "보험만료일";
		value_nm[8]  = "배서항목명";
		value_nm[9]  = "변경전";
		value_nm[10] = "변경후";
		value_nm[11] = "변경사유";
		value_nm[12] = "변경요청일";
		value_nm[13] = "비고";
		value_nm[14] = "보험사코드";
		value_nm[36] = "상호(보험사용)";
		value_nm[38] = "피보험자변경";
	}	
	
	if(iec_bean.getGubun().equals("해지")){
		value_nm[10] = "피보험자변경";
	}	
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<script language='javascript'>
<!--
	function update(){
		var fm = document.form1;
		fm.action = 'ins_com_u_a.jsp';
		fm.target = 'i_no';
		fm.submit();
	}
	
//-->
</script>
<style type=text/css>

<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=15>
<form name='form1' action='' target='' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>
  <input type='hidden' name='reg_code' value='<%=reg_code%>'>
  <input type='hidden' name='seq' value='<%=seq%>'>

<div class="navigation">
	<span class=style1>보험관리 ></span><span class=style5>보험요청내용</span>
</div>

<table border="0" cellspacing="0" cellpadding="0" width='650'>    
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='200' class='title'>구분</td>
					<td width='450' class='title'>값</td>
			  </tr>
			  <%for (int i = 1 ; i <= b_size ; i++){%>
			   <%  if(value_nm[i] != null){%>
				<tr>
					<td class='title'><%=value_nm[i]%></td>
					<td>&nbsp;<input type='text' name="value<%=AddUtil.addZero2(i)%>" value='<%=ht.get("VALUE"+AddUtil.addZero2(i))%>' size="60"></td>
			  </tr>
			  	<%}%>
			  <%}%>
			</table>
		</td>
	</tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">		
		<%	if(nm_db.getWorkAuthUser("전산팀",user_id)||nm_db.getWorkAuthUser("보험업무",user_id)){%>
		<a href="javascript:update()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
		<%	}%>
		<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
