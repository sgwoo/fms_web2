<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.user_mng.*, acar.cooperation.*, tax.*, acar.cont.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String vid[] 	= request.getParameterValues("ch2_cd");
	int vid_size = vid.length;
	
	String vid_num		= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAll("0003", "nm");
	int bank_size = banks.length;

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function save()
	{
		var fm = document.form1; //purc_gu
		<%	if(vid_size>1){
				for(int i=0;i < vid_size;i++){%>
					if( fm.jg_g_7[<%=i%>].value != '' || fm.purc_gu[<%=i%>].value == '1' || (fm.car_st[<%=i%>].value == '3' && ( fm.s_st[<%=i%>].value == '100' || fm.s_st[<%=i%>].value == '101' || fm.s_st[<%=i%>].value == '702' || fm.s_st[<%=i%>].value == '802' )) ){
						fm.acq_cng_yn[<%=i%>].value 	= 'N';
						fm.cpt_cd[<%=i%>].value 	= '';
					}		
					if(fm.acq_cng_yn[<%=i%>].value == '')						{	alert('명의변경여부를 선택하십시오');		return;	}
					if(fm.acq_cng_yn[<%=i%>].value == 'Y' && fm.cpt_cd[<%=i%>].value == '')		{	alert('금융사를 선택하십시오');			return;	}
		<%		}
			}else{%>
					if( fm.jg_g_7.value != '' || fm.purc_gu.value == '1' || (fm.car_st.value == '3' && ( fm.s_st.value == '100' || fm.s_st.value == '101' || fm.s_st.value == '702' || fm.s_st.value == '802'  )) ){
						fm.acq_cng_yn.value 	= 'N';
						fm.cpt_cd.value 	= '';
					}
					if(fm.acq_cng_yn.value == '')							{	alert('명의변경여부를 선택하십시오');		return;	}
					if(fm.acq_cng_yn.value == 'Y' && fm.cpt_cd.value == '')				{	alert('금융사를 선택하십시오');			return;	}
		<%	}%>	
		
		
		if(confirm('등록하시겠습니까?')){
			fm.action = "pur_pay_acq_cng_a.jsp";	
			fm.target='i_no';
			fm.submit();
		}
	}
	

	function cng_all_cngyn(value){
		var fm = document.form1;
		<%	if(vid_size>1){
				for(int i=0;i < vid_size;i++){%>
					if( fm.jg_g_7[<%=i%>].value != '' || fm.purc_gu[<%=i%>].value == '1' || (fm.car_st[<%=i%>].value == '3' && ( fm.s_st[<%=i%>].value == '100' || fm.s_st[<%=i%>].value == '101' || fm.s_st[<%=i%>].value == '702' || fm.s_st[<%=i%>].value == '802'  )) ){
						fm.acq_cng_yn[<%=i%>].value = 'N';
					}else{
						fm.acq_cng_yn[<%=i%>].value = value;
					}
		<%		}
			}else{%>
					if( fm.jg_g_7.value != '' || fm.purc_gu.value == '1' || (fm.car_st.value == '3' && ( fm.s_st.value == '100' || fm.s_st.value == '101' || fm.s_st.value == '702' || fm.s_st.value == '802'  )) ){
						fm.acq_cng_yn.value = 'N';
					}else{
						fm.acq_cng_yn.value = value;
					}
		<%	}%>	
	}	
	
	function cng_all_cptcd(value){
		var fm = document.form1;
		<%	if(vid_size>1){
				for(int i=0;i < vid_size;i++){%>
					if(fm.acq_cng_yn[<%=i%>].value == "Y"){
						fm.cpt_cd[<%=i%>].value = value;
						if( fm.jg_g_7[<%=i%>].value != '' || fm.purc_gu[<%=i%>].value == '1' || (fm.car_st[<%=i%>].value == '3' && ( fm.s_st[<%=i%>].value == '100' || fm.s_st[<%=i%>].value == '101' || fm.s_st[<%=i%>].value == '702' || fm.s_st[<%=i%>].value == '802'  )) ){
							fm.cpt_cd[<%=i%>].value = '';
						}
					}else{
						fm.cpt_cd[<%=i%>].value = '';
					}
		<%		}
			}else{%>
				if(fm.acq_cng_yn.value == "Y"){
					fm.cpt_cd.value = value;
					if( fm.jg_g_7.value != '' || fm.purc_gu.value == '1' || (fm.car_st.value == '3' && ( fm.s_st.value == '100' || fm.s_st.value == '101' || fm.s_st.value == '702' || fm.s_st.value == '802'  )) ){
						fm.cpt_cd.value = '';
					}
				}else{
					fm.cpt_cd.value = '';
				}
		<%	}%>	
	}		
	
	function cng_cptcd(value,idx){
		var fm = document.form1;
		if(value == 'Y'){
			<%	if(vid_size>1){%>
			if( fm.jg_g_7[idx].value != '' || fm.purc_gu[idx].value == '1' || (fm.car_st[idx].value == '3' && ( fm.s_st[idx].value == '100' || fm.s_st[idx].value == '101' || fm.s_st[idx].value == '702' || fm.s_st[idx].value == '802'  )) ){
				fm.acq_cng_yn[idx].value = 'N';
				value = 'N';
			}
			<%	}else{%>
			if( fm.jg_g_7.value != '' || fm.purc_gu.value == '1' || (fm.car_st.value == '3' && ( fm.s_st.value == '100' || fm.s_st.value == '101' || fm.s_st.value == '702' || fm.s_st.value == '802'  )) ){
				fm.acq_cng_yn.value = 'N';
				value = 'N';				
			}
			<%	}%>	
		}
		
		if(value == 'N' || value == ''){
			<%	if(vid_size>1){%>
			fm.cpt_cd[idx].value = '';
			<%	}else{%>
			fm.cpt_cd.value = '';
			<%	}%>				
		}
	}
//-->
</script>
</head>

<body>
<form action='' name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
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
<input type='hidden' name='sh_height' value='<%=sh_height%>'>




<table border=0 cellspacing=0 cellpadding=0 width=600>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 차량대금지급처리 > <span class=style5>취득세 명의변경 관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>일괄적용</span></td>
    </tr> 	
    <tr><td class=line2></td></tr>
    <tr>
    	<td class='line'>
    		<table border=0 cellspacing=1 cellpadding=0 width=100%>
			    <tr>
			    	<td width="100" class='title'>명의변경여부</td>
			    	<td width="200">&nbsp;
					  <select name='all_acq_cng_yn' class='default' onChange="javascript:cng_all_cngyn(this.value)">
                        <option value=''>선택</option>
						<option value='Y'>있음</option>
						<option value='N'>없음</option>
                      </select>		
					</td>
			    	<td width="100" class='title'>금융사</td>
					<td width="200">&nbsp;
					  <select name='all_cpt_cd' class='default' onChange="javascript:cng_all_cptcd(this.value)">
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        						for(int j = 0 ; j < bank_size ; j++){
        							CodeBean bank = banks[j];%>
                        <option value='<%= bank.getCode()%>'><%=bank.getNm()%></option>
                        <%		}
        					}%>
                      </select>
				    </td>
			    </tr>		
			</table>
		</td>
	</tr>		
    <tr>
        <td class=h></td>
    </tr> 		
    <tr><td class=line2></td></tr>
    <tr>
    	<td class='line'>
    		<table border=0 cellspacing=1 cellpadding=0 width=100%>
			    <tr>
			    	<td width="50" class='title'>연번</td>
			    	<td width="100" class='title'>계약번호</td>
			    	<td width="200" class='title'>상호</td>
					<td width="100" class='title'>명의변경여부</td>
			    	<td width="150" class='title'>금융사</td>
			    </tr>		
				<%for(int i=0;i < vid_size;i++){
					vid_num = vid[i];
					rent_mng_id 	= vid_num.substring(0,6);
					rent_l_cd 		= vid_num.substring(6,19);
					//장기계약 상단정보
					LongRentBean base = ScdMngDb.getScdMngLongRentInfo(rent_mng_id, rent_l_cd);
					//출고정보
					ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
					//납품준비상황
					Hashtable ht = a_db.getRentBoardSubCase(rent_l_cd);
					//차량기본정보
					ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
					%>	
				<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
				<input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>
				<input type='hidden' name='s_st' value='<%=base.getS_st()%>'>
				<input type='hidden' name='car_st' value='<%=base.getCar_st()%>'>
				<input type='hidden' name='jg_g_7' value='<%=String.valueOf(ht.get("JG_J_7"))%>'>
				<input type='hidden' name='purc_gu' value='<%=car.getPurc_gu()%>'>
			    <tr>
			    	<td align="center"><%=i+1%></td>				
			    	<td align="center"><%=rent_l_cd%></td>
			    	<td align="center"><%=base.getFirm_nm()%></td>
			    	<td align="center">
					  <select name='acq_cng_yn' onChange="javascript:cng_cptcd(this.value, <%=i%>)">
                                                <option value=''  <%if(pur.getAcq_cng_yn().equals(""))%>selected<%%>>선택</option>
						<option value='Y' <%if(pur.getAcq_cng_yn().equals("Y"))%>selected<%%>>있음</option>
						<option value='N' <%if(pur.getAcq_cng_yn().equals("N"))%>selected<%%>>없음</option>
                    </select>					
					</td>
			   		<td align="center">
					  <select name='cpt_cd'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        						for(int j = 0 ; j < bank_size ; j++){
        							CodeBean bank = banks[j];%>
                        <option value='<%= bank.getCode()%>' <%if(pur.getCpt_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                    </select>
				  </td>
			    </tr>
				<%}%>
			</table>
		</td>
	</tr>	
    <tr>
        <td class=h></td>
    </tr> 	
    <tr>
	    <td align='center'>
	    <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
	    <%}%>
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>			
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
			    