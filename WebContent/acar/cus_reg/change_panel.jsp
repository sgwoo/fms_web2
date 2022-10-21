<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");  //cmd:4(사고에서 자차정비등록)
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String accid_st = request.getParameter("accid_st")==null?"":request.getParameter("accid_st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	int result=0;
			
	if(rent_mng_id.equals("")||rent_l_cd.equals("")){
		Hashtable ht = c_db.getRent_id(car_mng_id);
		rent_mng_id = (String)ht.get("RENT_MNG_ID")==null?"":(String)ht.get("RENT_MNG_ID");
		rent_l_cd 	= (String)ht.get("RENT_L_CD")==null?"":(String)ht.get("RENT_L_CD");
	}
	
	//정비코드가 없으면 다음 정비코드 조회
	if(serv_id.equals("")){
		serv_id = cr_db.getServ_id(car_mng_id);
		result = cr_db.insertService(car_mng_id, serv_id, accid_id, rent_mng_id, rent_l_cd, ck_acar_id);	
	}
		
	ServInfoBean siBn = cr_db.getServInfo(car_mng_id, serv_id);
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();	

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		var fm = document.form1;
		if((fm.serv_dt.value == '')|| !isDate(fm.serv_dt.value))	{	alert('교환일자를 확인하십시오');		return;	}
		if((fm.rep_cont.value == '')){		alert('교환사유를 확인하십시오');		return;	}		
		if(fm.checker.value=="")		{	alert("점검자를 선택해 주세요!");		fm.checker.focus(); 		return; }
		if(toInt(fm.b_dist.value)==0)	{	alert("실주행거리를 입력해 주세요!");	fm.b_dist.focus(); 		return; }
		fm.target = 'i_no';
		//fm.target = 'about:blank';
		fm.submit();
	}

//팝업윈도우 열기
	function MM_openBrWindow2(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	

-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='change_panel_upd.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>
<input type="hidden" name="serv_st" value="4"> <!-- 계기판 교체-->
<input type='hidden' name='c_id' 		value='<%= car_mng_id %>'>
<input type='hidden' name='serv_id' 	value='<%= serv_id %>'>
<input type='hidden' name='off_id' 		value='<%= siBn.getOff_id() %>'>
<input type='hidden' name='cmd' 		value='<%= cmd %>'>
<input type='hidden' name='accid_id' 	value='<%= siBn.getAccid_id() %>'>
<input type='hidden' name='rent_mng_id' value='<%= rent_mng_id %>'>
<input type='hidden' name='rent_l_cd' 	value='<%= rent_l_cd %>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>계기판 교환</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
			    <td class='title' width=10%>점검자</td>
                                <td class='left' width=15%>&nbsp;
                                <select name="checker">
            			     <option value='' >=선택=</option>	
			            		                  <%	if(user_size > 0){
									for(int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i); %>
			                <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
			                <%		}
								}%>
			              </select></td>
				<tr>
					<td class='title'>교환일자 </td>
					<td>&nbsp;<input type='text' name='serv_dt'  value='<%=AddUtil.getDate()%>'  size='12' maxlength='12' class='text' onBlur='javascript:this.value = ChangeDate(this.value);'></td>
				</tr>
				<tr>
					<td class='title '> 주행거리</td>
					<td>&nbsp;변경전:<input name="b_dist"  class="num" size="7"  onBlur='javascript:this.value=parseDecimal(this.value)'>&nbsp;&nbsp;&nbsp;변경후:<input name="a_dist"  class="num" size="7" 	 onBlur='javascript:this.value=parseDecimal(this.value)'></td>
				</tr>
				<tr>
					<td class='title'>교환사유 </td>
					<td>&nbsp;<textarea name='rep_cont' cols='33' maxlength='255'></textarea> </td>
				</tr>
				<tr>
					<td class='title'>정비업체(작업) </td>
					<td>&nbsp;<input type='text' name='off_nm' size='30' maxlength='40' class='text'></td>
				</tr>
				
				<tr>
					<td class='title'>검사책임자(검사업체) </td>
					<td>&nbsp;<input type='text' name='cha_nm' size='30' maxlength='40' class='text' ></td>
				</tr>			
				
				<tr>
					<td class='title'>스캔 </td>
					<td>  <a class=index1 href="javascript:MM_openBrWindow2('/acar/accid_mng/upload.jsp?m_id=<%=siBn.getRent_mng_id()%>&l_cd=<%=siBn.getRent_l_cd()%>&c_id=<%=siBn.getCar_mng_id()%>&accid_id=<%=siBn.getAccid_id()%>&serv_id=<%=siBn.getServ_id()%>&mode=<%//=mode%>&gubun=pdf','popwin','scrollbars=no,status=no,resizable=yes,width=500,height=200,left=250, top=250')", title="자동차등록원부를 업로드하시려면 클릭하세요"><img src="/acar/images/center/button_in_reg.gif" align="absmiddle" border="0"></a>
				    * 자동차등록원부 첨부
					</td>
				
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align='right'><a href='javascript:save()'><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;<a href='javascript:window.close()'><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
	</tr>	
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>