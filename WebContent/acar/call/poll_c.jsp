<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.client.*, acar.common.*, acar.bill_mng.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
 	
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//변경화면
	function go_modify()
	{
		var fm = document.form1;
		fm.target = "d_content";
		fm.action = "client_u.jsp";		
		fm.submit();
	}
	
	function view_car_mgr(rent_mng_id, rent_l_cd)
	{
		var fm = document.form1;
		fm.action='/acar/mng_client2/car_mgr_in.jsp?rent_mng_id='+rent_mng_id+'&rent_l_cd='+rent_l_cd;
		fm.target='inner2';
		fm.submit();
	}
	
	function go_to_list()
	{
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var s_kd = fm.s_kd.value;
		var t_wd = fm.t_wd.value;
		var asc = fm.asc.value;
		location='/acar/mng_client2/client_s_frame.jsp?auth_rw='+auth_rw+'&s_kd='+s_kd+'&t_wd='+t_wd+'&asc='+asc;
	}
	//지점/현장관리
	function cl_site(client_id, firm_nm)
	{
		window.open('/acar/mng_client2/client_site_s_p.jsp?auth_rw='+document.form1.auth_rw.value+'&client_id='+client_id+'&firm_nm='+firm_nm, "CLIENT_SITE", "left=100, top=100, width=650, height=500, scrollbars=yes");
	}
	//사업장등록증이력
	function cl_enp_h(client_id, firm_nm)
	{
		var fm = document.form1;
		window.open("about:blank", "CLIENT_ENP", "left=50, top=50, width=900, height=500, scrollbars=yes");				
		fm.action = "client_enp_p.jsp";
		fm.target = "CLIENT_ENP";
		fm.submit();
//		window.open('/acar/mng_client2/client_enp_p.jsp?auth_rw='+document.form1.auth_rw.value+'&client_id='+client_id+'&firm_nm='+firm_nm, "CLIENT_ENP", "left=100, top=100, width=900, height=500, scrollbars=yes");
	}	
	function add_site(idx, val, str){
		document.form1.t_r_site[idx] = new Option(str, val);		
	}				

-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	int poll_id = request.getParameter("poll_id")==null?"0":request.getParameter("poll_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "03", "01");
	
	/*바로가기*/
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	ContBaseBean base 		= a_db.getContBaseAll(m_id, l_cd);
	
	if(c_id.equals(""))			c_id = base.getCar_mng_id();
	if(client_id.equals(""))	client_id = base.getClient_id();
	/*바로가기*/
	
	ClientBean client = al_db.getClient(client_id);
	
	Vector c_sites = al_db.getClientSites(client_id);
	int c_site_size = c_sites.size();
	
	//네오엠 거래처 정보
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Hashtable ven = new Hashtable();
	if(!client.getVen_code().equals("")){
		ven = neoe_db.getVendorCase(client.getVen_code());
	}
%>

<body>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td colspan="2"> <font color="navy">영업지원 -> </font><font color="navy">거래처
        관리 </font>-> <font color="red">거래처 보기</font> </td>
    </tr>
    <tr> 
      <td>
	  <font color="#999999">
        ♧ 최초등록자 : <%=c_db.getNameById(client.getReg_id(), "USER")%>&nbsp;&nbsp; ♧ 최초등록일 : 
        <%=AddUtil.ChangeDate2(client.getReg_dt())%>
		&nbsp;&nbsp;
        ♧ 최종수정자 : <%=c_db.getNameById(client.getUpdate_id(), "USER")%>&nbsp;&nbsp; ♧ 최종수정일 : 
        <%=AddUtil.ChangeDate2(client.getUpdate_dt())%>
        </font> 
      </td>
      <td align='right'>
        <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href="javascript:go_modify()" onMouseOver="window.status=''; return true"><img src="/images/up_info.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
        <%	}%>
        &nbsp;&nbsp;<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
	  </td>
    </tr>
    <tr> 
      <td colspan="2" class='line'> <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width='100'> 고객구분 </td>
            <td width='300'>&nbsp; 
              <%if(client.getClient_st().equals("1")) 		out.println("법인");
              	else if(client.getClient_st().equals("2"))  out.println("개인");
              	else if(client.getClient_st().equals("3")) 	out.println("개인사업자(일반과세)");
              	else if(client.getClient_st().equals("4"))	out.println("개인사업자(간이과세)");
              	else if(client.getClient_st().equals("5")) 	out.println("개인사업자(면세사업자)");%>
            </td>
            <td class='title' width='100'>개업년월일</td>
            <td width='307'>&nbsp;<%= client.getOpen_year()%></td>
          </tr>
          <tr> 
            <td class='title' width='85'> 상호</td>
            <td width='160'>&nbsp; 
            <%=client.getFirm_nm()%>            </td>
            <td class='title'>대표자</td>
            <td>&nbsp;<%=client.getClient_nm()%></td>
          </tr>
          <tr> 
            <td class='title'>주민(법인)번호</td>
            <td>&nbsp;<%=client.getSsn1()%>-<%=client.getSsn2()%></td>
            <td class='title'>사업자번호</td>
            <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
          </tr>
          <tr> 
            <td class='title'>본점소재지</td>
            <td colspan='3'>&nbsp; 
              <%if(!client.getHo_addr().equals("")){%>
              ( 
              <%}%>
              <%=client.getHo_zip()%> 
              <%if(!client.getHo_addr().equals("")){%>
              )&nbsp; 
              <%}%>
              <%=client.getHo_addr()%></td>
          </tr>
          <tr> 
            <td class='title'>사업장 주소</td>
            <td colspan='3'>&nbsp; 
              <%if(!client.getO_addr().equals("")){%>
              ( 
              <%}%>
              <%=client.getO_zip()%> 
              <%if(!client.getO_addr().equals("")){%>
              )&nbsp; 
              <%}%>
              <%=client.getO_addr()%></td>
          </tr>
          <tr> 
            <td class='title'>업태</td>
            <td>&nbsp;<%=client.getBus_cdt()%></td>
            <td class='title'>종목</td>
            <td>&nbsp;<%=client.getBus_itm()%></td>
          </tr>
		  <%if(client.getClient_st().equals("2")){%>		  
          <tr>
            <td width="100" class='title'>직장명</td>
            <td colspan="3">&nbsp;<%=client.getCom_nm()%></td>
          </tr>
          <tr>
            <td class='title'>근무부서</td>
            <td width="300">&nbsp;<%=client.getDept()%></td>
            <td width="100" class='title'>직위</td>
            <td width="307">&nbsp;<%=client.getTitle()%></td>
          </tr>
		  <%}%>		  
          <tr>
            <td width="100" class='title'>자택전화번호</td>
            <td width="300">&nbsp;<%=client.getH_tel()%></td>
            <td width="100" class='title'>회사전화번호</td>
            <td width="307">&nbsp;<%=client.getO_tel()%>&nbsp;<%=client.getM_tel()%></td>
          </tr>
          <tr>
            <td class='title'>휴대폰</td>
            <td>&nbsp;<%=client.getM_tel()%></td>
            <td class='title'>FAX</td>
            <td>&nbsp;<%=client.getFax()%></td>
          </tr>
          <tr>
            <td class='title'>Homepage</td>
            <td colspan="3">&nbsp;<a href='<%=client.getHomepage()%>' target='about:blank'><%=client.getHomepage()%></a></td>
          </tr>
          <tr>
            <td class='title'>담당자</td>
            <td colspan='3'><table border="0" cellspacing="1" cellpadding="0" width='650'>
                <tr>
                  <td width='155'>&nbsp;이름:<%=client.getCon_agnt_nm()%></td>
                  <td width='150'>사무실:<%=client.getCon_agnt_o_tel()%></td>
                  <td width='150'>이동전화:<%=client.getCon_agnt_m_tel()%></td>
                  <td width='150'>FAX:<%=client.getCon_agnt_fax()%></td>
                </tr>
                <tr>
                  <td>&nbsp;EMAIL:<%=client.getCon_agnt_email()%></td>
                  <td>근무부서:<%=client.getCon_agnt_dept()%></td>
                  <td colspan='2'>직위:<%=client.getCon_agnt_title()%></td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td class='title'>이메일수신거부</td>
            <td colspan="3">&nbsp;<%=client.getEtax_not_cau()%></td>
          </tr>
          <tr>
            <td width="100" class='title'>발행구분</td>
            <td width="300">&nbsp;
              <%if(client.getPrint_st().equals("1")) 		out.println("계약건별");
              	else if(client.getPrint_st().equals("2"))   out.println("거래처통합");
              	else if(client.getPrint_st().equals("3")) 	out.println("지점통합");
              	else if(client.getPrint_st().equals("4"))	out.println("현장통합");%>
				</td>
            <td width="100" align="center" class='title'>차량사용용도</td>
            <td width="307">&nbsp;<%=client.getCar_use()%></td>
          </tr>
          <tr>
            <td class='title'>자본금</td>
            <td>&nbsp;
                <%if(client.getFirm_price() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price())+"백만원/"+client.getFirm_day());%>
            </td>
            <td class='title'>연매출</td>
            <td>&nbsp;
            <%if(client.getFirm_price_y() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price_y())+"백만원/"+client.getFirm_day_y());%>              </td>
          </tr>
          <tr>
            <td class='title'>네오엠코드</td>
            <td colspan='3'>&nbsp;<%if(!client.getVen_code().equals("")){%>(<%=client.getVen_code()%>)&nbsp;<%=ven.get("VEN_NAME")%><%}%></td>
          </tr>		  
          <tr>
            <td class='title'> 특이사항 </td>
            <td colspan='3'><table border="0" cellspacing="1" cellpadding="4" width=650 height='40'>
                <tr>
                  <td><%=Util.htmlBR(client.getEtc())%> </td>
                </tr>
            </table></td>
          </tr>
        </table></td>
    </tr>
    <tr align="center"> 
      <td colspan="2">| <a href="javascript:cl_enp_h('<%=client_id%>','<%=client.getFirm_nm()%>')" onMouseOver="window.status=''; return true">사업장등록증 변경</a> | <a href="javascript:cl_site('<%=client_id%>','<%=client.getFirm_nm()%>')" onMouseOver="window.status=''; return true">지점/현장 관리</a> | </td>
    </tr>	
  </table>

	<tr>
		<td colspan='2'>
			<iframe src="/acar/mng_client2/con_s.jsp?client_id=<%=client_id%>" name="inner1" width="100%" height="130" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
		</td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="about:blank" name="inner2" width="100%" height="150" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>

</body>
</html>
