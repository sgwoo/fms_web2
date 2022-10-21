<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, cust.member.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="m_db" scope="page" class="cust.member.MemberDatabase"/>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");
	String s_gubun2 = request.getParameter("s_gubun2")==null?"":request.getParameter("s_gubun2");
	String s_gubun3 = request.getParameter("s_gubun3")==null?"":request.getParameter("s_gubun3");
	String s_gubun4 = request.getParameter("s_gubun4")==null?"":request.getParameter("s_gubun4");
	String rent_cnt = request.getParameter("rent_cnt")==null?"":request.getParameter("rent_cnt");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	
	ClientBean client = al_db.getClient(client_id);
	
	MemberBean bean = m_db.getMemberCase(client_id, r_site, member_id);	
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_to_list()
	{
		var fm = document.form1;
		var br_id = fm.br_id.value;
		var user_id = fm.user_id.value;
		var member_id = fm.member_id.value;
		var client_id = fm.client_id.value;			
		var r_site	= fm.r_site.value;								
		var auth_rw = fm.auth_rw.value;
		var s_gubun1 = fm.s_gubun1.value;
		var s_gubun2 = fm.s_gubun2.value;
		var s_gubun3 = fm.s_gubun3.value;		
		var s_gubun4 = fm.s_gubun4.value;
		var rent_cnt= fm.rent_cnt.value;		
		var idx 	= fm.idx.value;	
		location = "member_s_frame.jsp?br_id="+br_id+"&user_id="+user_id+"&member_id="+member_id+"&client_id="+client_id+"&r_site="+r_site+"&auth_rw="+auth_rw+"&s_gubun1="+s_gubun1+"&s_gubun2="+s_gubun2+"&s_gubun3="+s_gubun3+"&s_gubun4="+s_gubun4+"&rent_cnt="+rent_cnt+"&idx="+idx;
	}
	
	//ID 수정
	function save(){	
		var w = 430;
		var h = 250;
		var winl = (screen.width - w) / 2;
		var wint = (screen.height - h) / 2;
		var SUBWIN="member_u.jsp?member_id=<%=member_id%>&client_id=<%=client_id%>&r_site=<%=r_site%>&auth_rw=<%=auth_rw%>";	
		window.open(SUBWIN, "memberUp", "left="+winl+", top="+wint+", width="+w+", height="+h+", scrollbars=no");
		
	}
	
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name="br_id" value="<%=br_id%>">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="member_id" value="<%=member_id%>">
<input type='hidden' name="client_id" value="<%=client_id%>">
<input type='hidden' name="r_site" value="<%=r_site%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="s_gubun1" value="<%=s_gubun1%>">
<input type='hidden' name="s_gubun2" value="<%=s_gubun2%>">
<input type='hidden' name="s_gubun3" value="<%=s_gubun3%>">
<input type='hidden' name="s_gubun4" value="<%=s_gubun4%>">
<input type='hidden' name="rent_cnt" value="<%=rent_cnt%>">
<input type='hidden' name="idx" value="<%=idx%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객FMS > 아이디관리 > <span class=style5>회원정보</span></span></td>
					<td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
    <tr> 
        <td align='right'> 	  
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src="../images/center/button_close.gif"  aligh="absmiddle" border="0"></a> 
        </td>
    </tr>
    
	<tr>
		<td class=line2></td>
	</tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=13%> ID</td>
                    <td width=21%>&nbsp; <%=bean.getMember_id()%></td>
                    <td class='title' width=13%>비밀번호</td>
                    <td width=20%>&nbsp;<%=bean.getPwd()%></td>
                    <td class='title' width=13%>Email</td>
                    <td width=20%>&nbsp;<%=bean.getEmail()%></td>
                </tr>
            </table>
      </td>
    </tr>
    <tr> 
        <td align='right'>&nbsp;</td>
    </tr>
    <tr>
		<td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=13%> 고객구분 </td>
                    <td width=21%>&nbsp; 
                      <%if(client.getClient_st().equals("1")) 		out.println("법인");
                      	else if(client.getClient_st().equals("2"))  out.println("개인");
                      	else if(client.getClient_st().equals("3")) 	out.println("개인사업자(일반과세)");
                      	else if(client.getClient_st().equals("4"))	out.println("개인사업자(간이과세)");
                      	else if(client.getClient_st().equals("5")) 	out.println("개인사업자(면세사업자)");%>
                    </td>
                    <td class='title' width=13%>상호</td>
                    <td width=20%>&nbsp;<%=client.getFirm_nm()%></td>
                    <td class='title' width=13%>계약자</td>
                    <td width=20%>&nbsp;<%=client.getClient_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'>생년월일<br/>
                      (법인번호)</td>
                    <td>&nbsp;<%=client.getSsn1()%><%if(client.getClient_st().equals("1")){%>-<%=client.getSsn2()%><%}%></td>
                    <td class='title'>사업자등록번호</td>
                    <td>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
                    <td class='title'>차량사용용도</td>
                    <td>&nbsp;<%=client.getCar_use()%></td>
                </tr>
                <tr> 
                    <td class='title' height="21">직장명</td>
                    <td height="21">&nbsp;<%=client.getCom_nm()%></td>
                    <td class='title' height="21">근무부서</td>
                    <td height="21">&nbsp;<%=client.getDept()%></td>
                    <td class='title' height="21">직위</td>
                    <td height="21">&nbsp;<%=client.getTitle()%></td>
                </tr>
                <tr> 
                    <td class='title'>자택전화번호</td>
                    <td>&nbsp;<%=AddUtil.phoneFormat(client.getH_tel())%></td>
                    <td class='title'>회사전화번호</td>
                    <td>&nbsp;<%=AddUtil.phoneFormat(client.getO_tel())%></td>
                    <td class='title'>휴대폰</td>
                    <td>&nbsp;<%=AddUtil.phoneFormat(client.getM_tel())%></td>
                </tr>
                <tr> 
                    <td class='title'>FAX</td>
                    <td>&nbsp;<%=AddUtil.phoneFormat(client.getFax())%></td>
                    <td class='title'>Homepage</td>
                    <td colspan='3'>&nbsp;<a href='<%=client.getHomepage()%>' target='about:blank'><%=client.getHomepage()%></a></td>
                </tr>
                <tr> 
                    <td class='title'>본점소재지 주소</td>
                    <td colspan='5'>&nbsp; 
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
                    <td colspan='5'>&nbsp; 
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
                    <td class='title'>사용본거지</td>
                    <td colspan='5'>&nbsp; </td>
                </tr>
                <tr> 
                    <td class='title'>업태</td>
                    <td>&nbsp;<%=client.getBus_cdt()%></td>
                    <td class='title'>종목</td>
                    <td>&nbsp;<%=client.getBus_itm()%></td>
                    <td class='title'>개업년월일</td>
                    <td>&nbsp;<%= client.getOpen_year()%></td>
                </tr>
                <tr> 
                    <td class='title'>자본금/기준일</td>
                    <td>&nbsp; 
                      <%if(client.getFirm_price() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price())+"백만원/"+client.getFirm_day());%>
                    </td>
                    <td class='title'>연매출/기준일</td>
                    <td colspan="3">&nbsp; 
                      <%if(client.getFirm_price_y() > 0) out.println(AddUtil.parseDecimal(client.getFirm_price_y())+"백만원/"+client.getFirm_day_y());%>
                    </td>
                </tr>
                <tr> 
                    <td class='title'>고객계약담당자</td>
                    <td colspan='5'> 
                        <table border="0" cellspacing="1" cellpadding="0" width='605'>
                            <tr> 
                                <td width='155'>&nbsp;이름:<%=client.getCon_agnt_nm()%></td>
                                <td width='150'>사무실:<%=AddUtil.phoneFormat(client.getCon_agnt_o_tel())%></td>
                                <td width='150'>이동전화:<%=AddUtil.phoneFormat(client.getCon_agnt_m_tel())%></td>
                                <td width='150'>FAX:<%=AddUtil.phoneFormat(client.getCon_agnt_fax())%></td>
                            </tr>
                            <tr> 
                                <td>&nbsp;EMAIL:<%=client.getCon_agnt_email()%></td>
                                <td>근무부서:<%=client.getCon_agnt_dept()%></td>
                                <td colspan='2'>직위:<%=client.getCon_agnt_title()%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
