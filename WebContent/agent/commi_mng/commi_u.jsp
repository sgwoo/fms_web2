<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*, acar.commi_mng.*, acar.car_office.*"%>
<jsp:useBean id="acm_db" scope="page" class="acar.commi_mng.AddCommiDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"11":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
		
	String f_list = request.getParameter("f_list")==null?"now":request.getParameter("f_list");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
	
	if(emp_id.equals("")){
		Hashtable mgrs 		= a_db.getCommiNInfo(m_id, l_cd);
		Hashtable mgr_bus 	= (Hashtable)mgrs.get("BUS");
		emp_id = String.valueOf(mgr_bus.get("EMP_ID"))==null?"":String.valueOf(mgr_bus.get("EMP_ID"));
	}
	
    CarOffEmpBean emp = acm_db.getEmp(m_id, l_cd, emp_id);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 11; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height);//현황 라인수만큼 제한 아이프레임 사이즈
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//처리
	function submit_commi(idx, m_id, l_cd, emp_id, agnt_st)
	{
		if(confirm('처리하시겠습니까?'))
		{
			var fm = document.form1;
			var i_fm = inner.form1;			
			var commi_size = i_fm.commi_size.value;			
			if(commi_size == "1"){
				fm.commi.value = i_fm.commi.value;
				fm.inc_amt.value = i_fm.inc_amt.value;
				fm.res_amt.value = i_fm.res_amt.value;
				fm.tot_amt.value = i_fm.tot_amt.value;
				fm.dif_amt.value = i_fm.dif_amt.value;
				fm.sup_dt.value = i_fm.sup_dt.value;				
				fm.h_cust_st.value = i_fm.cust_st.value;								
			}else{
				fm.commi.value = i_fm.commi[idx].value;
				fm.inc_amt.value = i_fm.inc_amt[idx].value;
				fm.res_amt.value = i_fm.res_amt[idx].value;
				fm.tot_amt.value = i_fm.tot_amt[idx].value;
				fm.dif_amt.value = i_fm.dif_amt[idx].value;
				fm.sup_dt.value = i_fm.sup_dt[idx].value;
				fm.h_cust_st.value = i_fm.cust_st.value;								
			}			
			if(fm.sup_dt.value == '')			{		alert('지급일을 입력하십시오');	return;		}
			else if(!isDate(fm.sup_dt.value))	{		alert('지급일을 확인하십시오');	return;		}
			else if((!isCurrency(fm.commi.value)) || (fm.commi.lenght > 7))		{	alert('지급수수료를 확인하십시오');	return;	}
			else if((!isCurrency(fm.inc_amt.value)) || (fm.inc_amt.lenght > 6))	{	alert('소득세를 확인하십시오');		return;	}
			else if((!isCurrency(fm.res_amt.value)) || (fm.res_amt.lenght > 6))	{	alert('주민세를 확인하십시오');		return;	}
			else if((!isCurrency(fm.tot_amt.value)) || (fm.tot_amt.lenght > 7))	{	alert('누계를 확인하십시오');		return;	}
			else if((!isCurrency(fm.dif_amt.value)) || (fm.dif_amt.lenght > 7))	{	alert('차인지급액을 확인하십시오');	return;	}

			fm.m_id.value = m_id;			
			fm.l_cd.value = l_cd;
			fm.emp_id.value = emp_id;
			fm.agnt_st.value = agnt_st;
			fm.target='i_no';
			fm.action='/agent/commi_mng/commi_u_a.jsp';			
			fm.submit();
		}
	}

	//취소
	function cancel_commi(idx, m_id, l_cd, emp_id, agnt_st)
	{
		if(confirm('취소하시겠습니까?'))
		{
			var fm = document.form1;
			fm.m_id.value = m_id;			
			fm.l_cd.value = l_cd;
			fm.emp_id.value = emp_id;
			fm.agnt_st.value = agnt_st;
			fm.target='i_no';
			fm.action='/agent/commi_mng/commi_u_a.jsp';			
			fm.submit();
		}
	}
			
	//리스트로 가기
	function go_to_list(){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;
		var gubun3 	= fm.gubun3.value;
		var gubun4 	= fm.gubun4.value;		
		var st_dt 	= fm.st_dt.value;
		var end_dt 	= fm.end_dt.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		var f_list 	= fm.f_list.value;				
		location = "/agent/commi_mng/commi_frame_s.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc+"&f_list="+f_list;
	}	
	
	//세부페이지 이동
	function page_move()
	{
		var fm = document.form1;
		var url = "";
		var idx = fm.gubun1.options[fm.gubun1.selectedIndex].value;
			
		 if(idx == '11') url = "/agent/commi_mng/commi_u.jsp";										
					
		else return;										
		fm.action = url;		
		fm.target = 'd_content';	
		fm.submit();						
	}		

	function CommAdd(url){
		var fm = document.form1;
		fm.a_cust_st.value = '<%=emp.getCust_st()%>';
		fm.target='inner';
		fm.action=url;			
		fm.submit();		
	}
//-->
</script>
</head>

<body leftmargin=15>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type='hidden' name='emp_id' value='<%=emp_id%>'> 
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='h_cust_st' value=''>
<input type='hidden' name='agnt_st' value=''>
<input type='hidden' name='commi' value='0'>
<input type='hidden' name='inc_amt' value='0'>
<input type='hidden' name='res_amt' value='0'> 
<input type='hidden' name='tot_amt' value='0'>
<input type='hidden' name='dif_amt' value='0'>
<input type='hidden' name='sup_dt' value=''>
<input type='hidden' name='a_cust_st' value=''>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr> 
        <td colspan="2">
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;재무회계 > 영업비용관리 > 영업수당관리 > <span class=style1><span class=style5>지급수수료관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td align="right" colspan="2"> 
      
        &nbsp;&nbsp;<a href="javascript:go_to_list()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a> 
        </td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                    <td width=15% class=title> 
                      <%if(emp_id.equals("")){%>
                      <a href="javascript:set_car_off('BUS')" onMouseOver="window.status=''; return true" title="클릭하세요"><font color="FFFF00">자동차회사</font></a> 
                      <%}else{%>
                      자동차회사 
                      <%}%>
                    </td>
                    <td width=35%>&nbsp;<%=emp.getCar_comp_nm()%></td>
                    <td width=15% class=title>자동차영업소</td>
                    <td width=35%>&nbsp;<%=emp.getCar_off_nm()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="3" width="100%">
                <tr> 
                    <td class=title>고객구분</td>
                    <td colspan=3> &nbsp; <input type="radio" name="cust_st" value="1" <%if(emp.getCust_st().equals("1")){%>checked<%}%> disabled >
                      갑종근로소득&nbsp; <input type="radio" name="cust_st" value="2" <%if(emp.getCust_st().equals("2")){%>checked<%}%> disabled >
                      사업소득&nbsp; <input type="radio" name="cust_st" value="3" <%if(emp.getCust_st().equals("3")){%>checked<%}%> disabled >
                      기타사업소득&nbsp; <input type="radio" name="cust_st" value="4" <%if(emp.getCust_st().equals("4")){%>checked<%}%> disabled >
                      기타&nbsp; </td>
                    <td class=title>영업소구분</td>
                    <td> &nbsp; <input type="radio" name="car_off_st" value="1" <%if(emp.getCar_off_st().equals("1")){%>checked<%}%> disabled >
                      지점&nbsp; <input type="radio" name="car_off_st" value="2" <%if(emp.getCar_off_st().equals("2")){%>checked<%}%> disabled >
                      대리점&nbsp; </td>
                </tr>
                <tr> 
                    <td width=15% class=title>성명</td>
                    <td width=18%>&nbsp;<%=emp.getEmp_nm()%></td>
                    <td width=15% class=title>생년월일</td>
                    <td width=18%>&nbsp;<%=AddUtil.ChangeEnpH(emp.getEmp_ssn())%></td>
                    <td width=15% class=title>사무실전화</td>
                    <td width=19%>&nbsp;<%=emp.getCar_off_tel()%></td>
                </tr>
                <tr> 
                    <td class=title>휴대폰번호</td>
                    <td>&nbsp;<%=emp.getEmp_m_tel()%></td>
                    <td class=title>직위</td>
                    <td>&nbsp;<%=emp.getEmp_pos()%></td>
                    <td class=title>E-MAIL</td>
                    <td>&nbsp;<%=emp.getEmp_email()%></td>
                </tr>
                <tr> 
                    <td class=title>계좌개설은행</td>
                    <td>&nbsp;<%=emp.getEmp_bank()%></td>
                    <td class=title>예금주</td>
                    <td>&nbsp;<%=emp.getEmp_acc_nm()%></td>
                    <td class=title>계좌번호</td>
                    <td>&nbsp;<%=emp.getEmp_acc_no()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>지급수수료</span></td>
        <td align="right">
    	  
        </td>
    </tr>
    <tr> 
        <td colspan="2"> <iframe src="/agent/commi_mng/commi_u_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&emp_id=<%=emp.getEmp_id()%>&cust_st=<%=emp.getCust_st()%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
<script language='javascript'>

</script>  
</body>
</html>