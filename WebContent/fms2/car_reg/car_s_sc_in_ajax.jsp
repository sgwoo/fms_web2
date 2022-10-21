<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="java.util.regex.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = "";
	String gubun_nm = "";
	String gubun = "";
	String ref_dt1 = "";
	String ref_dt2 = "";

	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("gubun") !=null) gubun = request.getParameter("gubun");

	if(request.getParameter("gubun_nm") != null) {
		gubun_nm = java.net.URLDecoder.decode((String) request.getParameter("gubun_nm"), "utf-8");
	}

	String sort 	= request.getParameter("sort")==null?"2":request.getParameter("sort");
	String car_ck 	= request.getParameter("car_ck")==null?"":request.getParameter("car_ck");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");

	String selectedPage = request.getParameter("selectedPage") == null ? "2" : request.getParameter("selectedPage");
	String rowsPerPage = request.getParameter("rowsPerPage") == null ? "100" : request.getParameter("rowsPerPage");

	// selectedPage 값이 숫자인지 체크
	if (!selectedPage.matches("-?\\d+(\\.\\d+)?")) {
		return;
	}

	// rowsPerPage 값이 숫자인지 체크
	if (!rowsPerPage.matches("-?\\d+(\\.\\d+)?")) {
		return;
	}

	Vector vt = ad_db.getServAllNew3(gubun, gubun_nm, gubun3, gubun2, sort, car_ck, Integer.parseInt(selectedPage), Integer.parseInt(rowsPerPage));

	int vt_size = vt.size();

	if (vt_size <= 0) {
%> EOR <%
	}

	long t_d1[] = new long[1];
	long t_d2[] = new long[1];

	float a_dis= 0;
 	long  l_a_dis = 0;

 	if (vt_size > 0) {
%>
				<tr>
					<td class='line' width='475' id='D1_col' style='position:relative;'>
						<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%
		for(int i = 0 ; i < vt_size ; i++) {
			Hashtable ht = (Hashtable)vt.elementAt(i);

			a_dis = AddUtil.parseFloat(String.valueOf(ht.get("SS")));

			l_a_dis = (long) a_dis;

			String rowNumber = "" + (((Integer.parseInt(selectedPage) - 1) * Integer.parseInt(rowsPerPage)) + i + 1);
%>
							<tr>
								<td  width='40' align='center'><%= rowNumber %></td>
								<td  width='100' align='center'><%=ht.get("RENT_L_CD")%></td>
								<td  width='75' align='center'><%=ht.get("RENT_DT")%></td>
								<td  width='120'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 8)%></span></td>
								<td  width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_DIST")))%></td>
								<td  width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("Y_AVE_DIST")))%>
								<span class="b"><a href="javascript:view_car_service('<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title="주행거리확인"><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0"></a></span>
								</td>
							</tr>
<%
		}
%>
						</table>
					</td>
					<td class='line' width='610'>
						<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%
		for(int i = 0 ; i < vt_size ; i++) {
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
							<tr>
								<td  width='70' align='center'>
									<a href="javascript:req_fee_start_act('주행거리 입력착오 수정바람', '<%=ht.get("CAR_NO")%> 현재주행거리<%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_DIST")))%>km, 연환산주행거리<%=AddUtil.parseDecimal(String.valueOf(ht.get("Y_AVE_DIST")))%>km -> 주행거리 입력 확인 필요 ', '<%=ht.get("MNG_ID")%>')" onMouseOver="window.status=''; return true" title='관리담당자에게 주행거리 확인 요청하기'>			
									<%=ht.get("MNG_NM")%>
									</a> 
								</td>
								<td  width='90' align='center'><a href="javascript:view_car_dist('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title="주행거리입력"><span title='<%=ht.get("CAR_MNG_ID")%>'><%=ht.get("CAR_NO")%></span></a></td>							
								<td  width='150'>&nbsp;<%=Util.subData(String.valueOf(ht.get("CAR_NAME")), 10)%></td>					
								<td  width='75' align='center'><%=ht.get("INIT_REG_DT")%></td>								
								<td  width='75' align='center'><%=ht.get("RENT_START_DT")%></td>
								<td  width='75' align='center'><%=ht.get("RENT_WAY_NM")%></td>
								<td  width='75' align='center'><span title='<%=ht.get("DDTT")%>'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TOT_DT")))%></span></td>													
							</tr>
<%
		}
%>
						</table>
					</td>
<%	} %>