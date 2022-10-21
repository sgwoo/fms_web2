<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.car_register.*" %>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	CarRegDatabase cdb = CarRegDatabase.getInstance();
	RentListBean rl_r [] = cdb.getRegListAll2(br_id, st, ref_dt1, ref_dt2, gubun, gubun_nm, gubun3, q_sort_nm, q_sort);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
//한건조회
function CarRegList(brch_id, rent_mng_id, rent_l_cd, car_mng_id, reg_gubun, rpt_no, firm_nm, client_nm, imm_amt, car_name, dlv_dt)
{
	var theForm = document.CarRegDispForm;
	theForm.rent_mng_id.value 	= rent_mng_id;
	theForm.rent_l_cd.value 	= rent_l_cd;
	theForm.car_mng_id.value 	= car_mng_id;
	theForm.cmd.value 			= reg_gubun;
	theForm.action = "./register_frame.jsp";
	theForm.target = "d_content"
//	if(dlv_dt == ''){ alert('출고일자가 없으면 등록하지 못합니다.'); return; }
	theForm.submit();
}
function view_client(rent_mng_id, rent_l_cd, r_st)
{
	var SUBWIN="/fms2/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;	
	window.open(SUBWIN, "View_CLIENT", "left=50, top=50, width=820, height=700, resizable=yes, scrollbars=yes");
}
/* Title 고정 */
function setupEvents()
{
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
}

function moveTitle()
{
    var X ;
    document.all.title.style.pixelTop = document.body.scrollTop ;
                                                                              
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;   
    
}
function init() {
	
	setupEvents();
}



function dg_input(rent_mng_id, rent_l_cd, car_mng_id, user_id)
{
	var SUBWIN="/acar/cus_pre/dg_i.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&car_mng_id="+car_mng_id+"&user_id="+user_id;	
	window.open(SUBWIN, "dg_input", "left=50, top=50, width=820, height=150, resizable=yes, scrollbars=yes");
}



//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}

//-->
</script>
</head>
<body>

<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
                <table border=0 cellspacing=1 cellpadding=0 width=100%>
                            <tr> 
                                <td width=3% class=title>연번</td>
                                <td width=10% class=title><%if(st.equals("1") || st.equals("3")){%>계출번호<%}else{%>계약번호<%}%></td>
                                <td width=12% class=title>상호</td>
                                <td width=5% class=title><%if(st.equals("1") || st.equals("3")){%>담당자<%}else{%>성명<%}%></td>
                                <td width=8% class=title>차량번호</td>
                                <td width=10% class=title>차량관리번호</td>
                                <td width=16% class=title>차명</td>                				                				
                				<td width=9% class=title><% if(st.equals("1")||st.equals("3")) { %>계약일<% }else{%>등록일<%}%></td>                                
                                <td width=9% class=title><% if(st.equals("2")) { %>차령만료일<% } else if(st.equals("3")) { %>출고예정일<% } else if(st.equals("1")) { %>출고일<%}else{%>관리번호<% } %></td>
                                <td width=6% class=title>용도</td>
                                <td width=6% class=title>지역</td>
                                <td width=6% class=title>지점</td>
                            </tr>
                            <%if(rl_r.length != 0){ %>
                          <% 	for(int i=0; i<rl_r.length; i++){
                    				rl_bean = rl_r[i];%>
                            <tr> 
                                <td width=3% align="center">
                              <%=i+1%></td>
                                <td width=10% align="center"><%if(st.equals("1") || st.equals("3")){%><%= rl_bean.getRpt_no() %><%}else{%><%= rl_bean.getRent_l_cd() %><%}%></td>
                                <td width=12% align="left">&nbsp;<span title=" <%= rl_bean.getFirm_nm() %>"><a href="javascript:view_client('<%=rl_bean.getRent_mng_id()%>','<%=rl_bean.getRent_l_cd()%>','<%=rl_bean.getR_st()%>')"><%= Util.subData(rl_bean.getFirm_nm(),12) %></a></span></td>
                                <td width=5% align="center"><%if(st.equals("1") || st.equals("3")){%><%= rl_bean.getBus_nm() %><%}else{%><%= Util.subData(rl_bean.getClient_nm(),3) %><%}%></td>
                                <td width=8% align="center"><a href="javascript:CarRegList('<%= rl_bean.getBr_id() %>','<%= rl_bean.getRent_mng_id() %>','<%= rl_bean.getRent_l_cd() %>','<%= rl_bean.getCar_mng_id() %>','<%= rl_bean.getReg_gubun() %>','<%= rl_bean.getRpt_no() %>','<%= rl_bean.getFirm_nm() %>','<%= rl_bean.getClient_nm() %>','<%= rl_bean.getImm_amt() %>','<%=rl_bean.getCar_name()%>','<%= rl_bean.getDlv_dt() %>')" onMouseOver="window.status=''; return true"><%= rl_bean.getCar_no() %></a></td>
                                <td width=10% align="center">
                                <%if(rl_bean.getCar_doc_no().equals("")){ %>미지정<%}else{ %><%= rl_bean.getCar_doc_no() %><%} %>
                                </td>
                                <td width=16% align="left">&nbsp;<span title="<%=rl_bean.getCar_nm()%> <%=rl_bean.getCar_name()%>"><%= Util.subData(rl_bean.getJg_g_16()+" "+rl_bean.getCar_nm()+" "+rl_bean.getCar_name(),17) %></span></td>
                                
       				<% if (st.equals("1") || st.equals("3")) { %>
                                <td width=9% align="center"><%= rl_bean.getRent_dt() %></td>				
       				<% }else{%>
                                <td width=9% align="center"><%= rl_bean.getInit_reg_dt() %></td>								
                		<% }%>
                		
                                <% if (st.equals("2")) { %>
                                <td width=9% align="center"><%= AddUtil.ChangeDate2(rl_bean.getCar_end_dt()) %></td>
                                <% } else if(st.equals("3")) { %>
                                <td width=9% align="center"><%= rl_bean.getDlv_est_dt() %></td>
                                <% } else if(st.equals("1")) { %>
                                <td width=9% align="center"><%= rl_bean.getDlv_dt() %></td>
                                <% } else { %>
                                <td width=9% align="center"><%= rl_bean.getCar_doc_no() %></td>
                                <% } %>
                                
                                <td width=6% align="center"><%if(rl_bean.getCar_st().equals("리스")){%><font color=red>리스</font><%}else{%><%= rl_bean.getCar_st() %><%}%></td>
                                <td width=6% align="center"><%=c_db.getNameByIdCode("0032", "", rl_bean.getCar_ext())%></td>
                                <td width=6% align="center"><%=rl_bean.getBr_id() %></td>
                            </tr>
                          <%	}%>
                          <%}%>			  
            			  <%if(rl_r.length == 0){ %>			  
                            <tr> 
                                <td colspan="12" align="center">&nbsp;등록된 데이타가 없습니다.</td>
                            </tr>
            			  <%}%>			  
            </table>
        </td>
    </tr>
</table>
<form action="./register_frame.jsp" name="CarRegDispForm" method="POST">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="ref_dt1" value="<%=ref_dt1%>">
<input type="hidden" name="ref_dt2" value="<%=ref_dt2%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="q_sort_nm" value="<%=q_sort_nm%>">
<input type="hidden" name="q_sort" value="<%=q_sort%>">
<input type="hidden" name="rent_mng_id" value="">
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="cmd" value="">
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=rl_r.length%>';
//-->
</script>
</body>
</html>