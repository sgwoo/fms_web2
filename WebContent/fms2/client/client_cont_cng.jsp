<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	ClientBean client = al_db.getNewClient(client_id);
	
	Vector cars = al_db.getClientMgrList(client_id);
	int car_size = cars.size();
	
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function Search(){
		var fm = document.form1;
		if(fm.t_wd.value==""){	alert("상호명을 입력해 주세요!"); fm.t_wd.focus();	return; }
		fm.action =  '/acar/mng_client2/cr_c_visit.jsp';		
		fm.target = 'i_no';	
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}		
	
	function update_client_etc(){
		var fm = document.form1;
		window.open('client_u_mini.jsp?client_id=<%=client_id%>&firm_nm=<%=client.getFirm_nm()%>&client_nm=<%=client.getClient_nm()%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>&from_page=<%=from_page%>', "CLIENT_ETC", "left=100, top=100, width=850, height=475, resizable=yes, scrollbars=yes, status=yes");
	}

	function mgr_modify(m_id, l_cd, mgr_st, car_no){
		var fm = document.form1;
		window.open('/acar/mng_client2/mgr_addr.jsp?m_id='+m_id+'&l_cd='+l_cd+'&mgr_st='+mgr_st+'&car_no='+car_no+'&client_id=<%=client_id%>&firm_nm=<%=client.getFirm_nm()%>&client_nm=<%=client.getClient_nm()%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>&from_page=<%=from_page%>', "MGR_ADDR"+l_cd+mgr_st, "left=100, top=100, width=650, height=275, resizable=yes, scrollbars=yes, status=yes");
	}
	
	function post_modify(m_id, l_cd, mgr_st, car_no){
		var fm = document.form1;
		window.open('/acar/mng_client2/post_addr.jsp?m_id='+m_id+'&l_cd='+l_cd+'&mgr_st='+mgr_st+'&car_no='+car_no+'&client_id=<%=client_id%>&firm_nm=<%=client.getFirm_nm()%>&client_nm=<%=client.getClient_nm()%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>&from_page=<%=from_page%>', "MGR_ADDR"+l_cd+mgr_st, "left=100, top=100, width=650, height=320, resizable=yes, scrollbars=yes, status=yes");
	}		

	function lic_modify(m_id, l_cd, mgr_st, car_no){
		var fm = document.form1;
		window.open('/acar/mng_client2/lic_addr.jsp?m_id='+m_id+'&l_cd='+l_cd+'&mgr_st='+mgr_st+'&car_no='+car_no+'&client_id=<%=client_id%>&firm_nm=<%=client.getFirm_nm()%>&client_nm=<%=client.getClient_nm()%>&auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&asc=<%=asc%>&from_page=<%=from_page%>', "MGR_ADDR"+l_cd+mgr_st, "left=100, top=100, width=750, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}			
	
	//일괄등록
	function select_mgr_reg(mgr_st){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("변경할 계약을 선택하세요.");
			return;
		}	
		fm.mgr_st.value = mgr_st;
		fm.target = "_blank";
		fm.action = "/acar/mng_client2/mgr_addr_select.jsp";
		fm.submit();	
	}					
	//일괄등록
	function select_post_reg(mgr_st){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("변경할 계약을 선택하세요.");
			return;
		}	
		fm.mgr_st.value = mgr_st;
		fm.target = "_blank";
		fm.action = "/acar/mng_client2/post_addr_select.jsp";
		fm.submit();	
	}				
	//일괄등록
	function select_lic_reg(mgr_st){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("변경할 계약을 선택하세요.");
			return;
		}	
		fm.mgr_st.value = mgr_st;
		fm.target = "_blank";
		fm.action = "/acar/mng_client2/lic_addr_select.jsp";
		fm.submit();	
	}	
	
	//스캔관리 보기
	function view_scan(m_id, l_cd)
	{		
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SCAN", "left=100, top=100, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");				
	}		
			
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>

<input type='hidden' name='size' value='<%=car_size%>'>
<input type='hidden' name='cng_gubun' value='post'>
<input type='hidden' name='s_gubun1' value='1'>
<input type='hidden' name='m_st1' value=''>
<input type='hidden' name='m_st2' value=''>
<input type='hidden' name='m_st3' value=''>
<input type='hidden' name='m_mail1' value=''>
<input type='hidden' name='m_mail2' value=''>
<input type='hidden' name='m_mail3' value=''>
<input type='hidden' name='mm_yn1' value=''>
<input type='hidden' name='mm_yn2' value=''>
<input type='hidden' name='mm_yn3' value=''>
<input type='hidden' name='mgr_st' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 고객관리 > <span class=style5>고객 일괄변경</span></span> : 고객 일괄변경</td>
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
                <tr>
                    <td width='10%' class='title'>상호</td>
                    <td width="39%">&nbsp;<%=client.getFirm_nm()%></td>
                    <td width="4%" rowspan="2" class='title'>계<br>약<br>자</td>
                    <td width="8%" class='title'>성명</td>
                    <td width="31%">&nbsp;<%=client.getClient_nm()%></td>
                </tr>
                <tr>
                    <td class='title'>이용차량대수</td>
                    <td width="300">&nbsp;<%=car_size%>&nbsp;대</td>
                    <td class='title'>대표전화</td>
                    <td width="307">&nbsp;<%=client.getO_tel()%></td>
                </tr>
                <tr>
                    <td class='title'>주소</td>
                    <td>&nbsp;<%=client.getO_addr()%></td>
                    <td colspan="2" class='title'>운전면허번호</td>
                    <td>&nbsp;<%=client.getLic_no()%></td>
                </tr> 
                <tr>
                    <td class='title'>계산서담당자</td>
                    <td colspan="4">&nbsp;<a href="javascript:update_client_etc();"><%=client.getCon_agnt_nm()%>&nbsp;<%=client.getCon_agnt_title()%>&nbsp;<%=client.getCon_agnt_o_tel()%>&nbsp;<%=client.getCon_agnt_m_tel()%>&nbsp;<%=client.getCon_agnt_email()%></a></td>
                </tr>
                
                </tr>                
		    </table>
        </td>
	</tr>
	<tr>
	    <td>&nbsp;</td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
	<tr>
	    <td align='right' class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='3%' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
					<td width='4%' class='title'>연번</td>					
                    <td width='8%' class='title'>차량번호</td>
                    <td width='20%' class='title'>우편물주소&nbsp;<a href="javascript:select_post_reg('');"><img src="/acar/images/center/button_in_modify_ig.gif" align="absmiddle" border="0"></a></td>
                    <td width='15%' class='title'>운전면허번호&nbsp;<a href="javascript:select_lic_reg('');"><img src="/acar/images/center/button_in_modify_ig.gif" align="absmiddle" border="0"></a></td>
                    <td width='15%' class='title'>차량이용자&nbsp;<a href="javascript:select_mgr_reg('차량이용자');"><img src="/acar/images/center/button_in_modify_ig.gif" align="absmiddle" border="0"></a></td>
                    <td width='15%' class='title'>차량관리자&nbsp;<a href="javascript:select_mgr_reg('차량관리자');"><img src="/acar/images/center/button_in_modify_ig.gif" align="absmiddle" border="0"></a></td>
                    <td width='15%' class='title'>회계관리자&nbsp;<a href="javascript:select_mgr_reg('회계관리자');"><img src="/acar/images/center/button_in_modify_ig.gif" align="absmiddle" border="0"></a></td>
                    <td width='5%' class='title'>스캔</td>
                </tr>
<%	if(car_size > 0){
		for(int i = 0 ; i < car_size ; i++){
			Hashtable car = (Hashtable)cars.elementAt(i);%>		
                <tr>
					<td <%if(String.valueOf(car.get("USE_YN")).equals("N")){%>class=is<%}%> align='center'><input type="checkbox" name="ch_cd" value="<%=car.get("RENT_MNG_ID")%><%=car.get("RENT_L_CD")%>"></td>
					<td <%if(String.valueOf(car.get("USE_YN")).equals("N")){%>class=is<%}%> align="center"><%=i+1%><%if(String.valueOf(car.get("USE_YN")).equals("N")){%><br>(해지)<%}%></td>
					<td <%if(String.valueOf(car.get("USE_YN")).equals("N")){%>class=is<%}%> align="center"><%=car.get("CAR_NO")%><br>(<%=car.get("RENT_L_CD")%>)</td>
					<td <%if(String.valueOf(car.get("USE_YN")).equals("N")){%>class=is<%}%> align="center">[<%=car.get("TAX_TYPE")%>]<a href="javascript:post_modify('<%=car.get("RENT_MNG_ID")%>', '<%=car.get("RENT_L_CD")%>', '', '<%=car.get("CAR_NO")%>')" onMouseOver="window.status=''; return true"><%=car.get("P_ADDR")%></a><br><br>&nbsp;<%=car.get("TAX_AGNT")%><br>(<%=car.get("RENT_DT")%>)</td>
					<!-- 운전면허번호추가(20180921) -->
					<td <%if(String.valueOf(car.get("USE_YN")).equals("N")){%>class=is<%}%> align="center"><a href="javascript:lic_modify('<%=car.get("RENT_MNG_ID")%>', '<%=car.get("RENT_L_CD")%>', '', '<%=car.get("CAR_NO")%>')" onMouseOver="window.status=''; return true"><%=car.get("LIC_NO")%>
						<%if(!String.valueOf(car.get("MGR_LIC_NO")).equals("")){%>
						  <br><%=car.get("MGR_LIC_NO")%> <%=car.get("MGR_LIC_EMP")%> <%=car.get("MGR_LIC_REL")%>
						<%}%>
						</a>
					</td>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td align="center" style='height:21'><a href="javascript:mgr_modify('<%=car.get("RENT_MNG_ID")%>', '<%=car.get("RENT_L_CD")%>', '차량이용자', '<%=car.get("CAR_NO")%>')" onMouseOver="window.status=''; return true"><%=car.get("MGR_NM1")%></a></td>
                            </tr>
                            <tr>
                                <td align="center" style='height:21'><%=car.get("MGR_TEL1")%></td>
                            </tr>
                            <tr>
                                <td align="center" style='height:21'><%=car.get("MGR_EMAIL1")%></td>
                            </tr>
                            <tr>
                                <td align="center" style='height:21'><%=car.get("MGR_LIC_NO1")%></td><!-- 운전면허번호추가(20180928) -->
                            </tr>
                        </table>
                    </td>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td align="center" style='height:21'><a href="javascript:mgr_modify('<%=car.get("RENT_MNG_ID")%>', '<%=car.get("RENT_L_CD")%>', '차량관리자', '<%=car.get("CAR_NO")%>')" onMouseOver="window.status=''; return true"><%=car.get("MGR_NM2")%></a></td>
                            </tr>
                            <tr>
                                <td align="center" style='height:21'><%=car.get("MGR_TEL2")%></td>
                            </tr> 
                            <tr>
                                <td align="center" style='height:21'><%=car.get("MGR_EMAIL2")%></td>
                            </tr>
                            <tr>
                                <td align="center" style='height:21'><%=car.get("MGR_LIC_NO2")%></td><!-- 운전면허번호추가(20180928) -->
                            </tr> 
                        </table>
                    </td>
                    <td>
                        <table width=100% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td align="center" style='height:21'><a href="javascript:mgr_modify('<%=car.get("RENT_MNG_ID")%>', '<%=car.get("RENT_L_CD")%>', '회계관리자', '<%=car.get("CAR_NO")%>')" onMouseOver="window.status=''; return true"><%=car.get("MGR_NM3")%></a></td>
                            </tr>
                            <tr>
                                <td align="center" style='height:21'><%=car.get("MGR_TEL3")%></td>
                            </tr>
                            <tr>
                                <td align="center" style='height:21'><%=car.get("MGR_EMAIL3")%></td>
                            </tr>
                            <tr>
                                <td align="center" style='height:21'><%=car.get("MGR_LIC_NO3")%></td><!-- 운전면허번호추가(20180928) -->
                            </tr>
                        </table>
                    </td>
                    <td align="center"><a href="javascript:view_scan('<%=car.get("RENT_MNG_ID")%>', '<%=car.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='스캔관리'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
                </tr>
<%		}
	}%>
            </table>
        </td>
    </tr>	
	<tr>
	    <td><span class=style3>* 관계자변경시 동일인물은 한건만 입력해도 일괄 자동입력</span></td>
    </tr>
	<tr>
	    <td><span class=style3>* 일괄변경을 할 경우에는 계약을 선택한 후 일괄변경 버튼을 클릭하세요.</span></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
