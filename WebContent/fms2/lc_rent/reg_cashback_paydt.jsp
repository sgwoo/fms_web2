<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_mst.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");

	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
%>
<%	

	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	
	//기본정보
	Hashtable cont = a_db.getContViewCase(m_id, l_cd);	
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(m_id, l_cd);
	
	//차량기본정보
	ContCarBean car = a_db.getContCarNew(m_id, l_cd);	
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(cont.get("CAR_ID")), String.valueOf(cont.get("CAR_SEQ")));
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function update(){		
		var fm = document.form1;
		fm.action='reg_cashback_paydt_a.jsp';		
		fm.target='i_no';
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name="m_id" value="<%=m_id%>">
  <input type='hidden' name="l_cd" value="<%=l_cd%>">

<table border="0" cellspacing="0" cellpadding="0" width=570>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>수입차캐쉬백</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	      
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='14%'>계약번호</td>
                    <td width='31%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='14%'>상호</td>
                    <td width='41%'>&nbsp;<%=cont.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>제조사</td>
                    <td>&nbsp;<%=cm_bean.getCar_comp_nm()%></td>
                    <td class='title'>차명</td>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td><%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp; </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='20%'>Cash Back<br>약정금액</td>
                    <td>&nbsp;<%= AddUtil.parseDecimal(car.getImport_cash_back())%>원</td>
                </tr>    
                <tr>    
                    <td class='title'>수금금액</td>
                    <td>&nbsp;<input type='text' name='r_import_cash_back' value='<%= AddUtil.parseDecimal(car.getR_import_cash_back())%>'size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
                </tr>
                <tr>    
                    <td class='title'>수금일자</td>
                    <td>&nbsp;<input type='text' size='11' name='cash_back_pay_dt' class='text' value='<%=AddUtil.ChangeDate2(cont_etc.getCash_back_pay_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>

            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">
		<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
		<a href='javascript:update()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
		<%}%>
		<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
			  
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
