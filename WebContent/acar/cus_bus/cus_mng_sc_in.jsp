<%@ page language="java" contentType="text/html; charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cus_bus.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String dt = "2";
	String ref_dt1 = Util.getDate();
	String ref_dt2 = Util.getDate();
	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("dt") != null)	dt = request.getParameter("dt");
	if(request.getParameter("ref_dt1") != null)	ref_dt1 = request.getParameter("ref_dt1");
	if(request.getParameter("ref_dt2") != null)	ref_dt2 = request.getParameter("ref_dt2");
	
	CusBus_Database cb_db = CusBus_Database.getInstance();
	
	if(gubun4.equals("zzzzzz")) return;
	

	Vector conts =  cb_db.getContList_c(dt, ref_dt1, ref_dt2, gubun1, gubun2, gubun3, gubun4, sort);
	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function set_mng(mode,rmg,rld){
	var SUBWIN="./cus_mng_set.jsp?rent_mng_id="+rmg+"&rent_l_cd="+rld+"&mode="+mode;
	window.open(SUBWIN, "setMng", "left=650, top=200, width=200, height=100, scrollbars=no");
}	
//-->
</script>
</head>
<body>
<form name="form1">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td class="line"><table width="100%" border="0" cellspacing="1" cellpadding="0">
<% if(conts.size()>0){
				long t_amt1[] = new long[1];
				long t_amt2[] = new long[1];
		  		for(int i=0; i<conts.size(); i++){
					RentListBean cont = (RentListBean)conts.elementAt(i); 
					
					for(int j=0; j<1; j++){
						t_amt1[j] += cont.getImm_amt();
						t_amt2[j] += cont.getReg_amt();
					} 
%>
        <tr> 
          <td style="font-size:8pt" width='3%' align='center'><%= i+1 %></td>         
          <td style="font-size:8pt" width='8%' align='center'><%= cont.getRent_l_cd() %></td>
          <td style="font-size:8pt" align='left'>&nbsp;<%= cont.getFirm_nm() %></td>
          <td style="font-size:8pt" width='6%' align='center'><%= cont.getCar_no() %></td>
          <td style="font-size:8pt" width='7%' align='left'>&nbsp;<span title="<%= cont.getCar_nm() %>"><%= AddUtil.subData(cont.getCar_nm(),6) %></span></td>
          <td style="font-size:8pt" width='6%' align='center'><%= cont.getInit_reg_dt() %></td>
          <td style="font-size:8pt" width='6%' align='center'><%= cont.getRent_dt() %></td>
          <td style="font-size:8pt" width='5%' align='right'><%= AddUtil.parseDecimal(cont.getImm_amt()) %></td> 
          <td style="font-size:8pt" width='5%' align='right'><%= cont.getDlv_dt() %>&nbsp;</td> 
          <td style="font-size:8pt" width='3%' align='right'><%= cont.getCar_ja() %>&nbsp;</td> 
          <td style="font-size:8pt" width='5%' align='right'><%= AddUtil.parseDecimal(cont.getReg_amt()) %></td> 
          <td style="font-size:8pt" width='5%' align='center'><%= cont.getRent_way() %></td>
          <td style="font-size:8pt" width='3%' align='center'><% if(cont.getCar_st().equals("1")) out.print("렌트"); else if(cont.getCar_st().equals("2")) out.print("보유"); else if(cont.getCar_st().equals("3")) out.print("리스"); %></td>
          <td style="font-size:8pt" width='6%' align='center'><%= cont.getEst_area() %></td>
          <td style="font-size:8pt" width='8%' align='center'><%= cont.getCpt_cd() %></td>		  
          <td style="font-size:8pt" width='3%' align='center'><%= cont.getCon_mon() %></td>
          <td style="font-size:8pt" width='4%' align='center'><%= c_db.getNameById(cont.getBus_id(),"USER") %></td>
          <td style="font-size:8pt" width='4%' align='center'><%= c_db.getNameById(cont.getBus_id2(),"USER") %></td>
          <td style="font-size:8pt" width='4%' align='center'><% if(cont.getMng_id().equals("")){ %><% }else{ %><%= c_db.getNameById(cont.getMng_id(),"USER") %><% } %></td>        		
        </tr>
        <% 		} %>
         <TR> 
            <TD colspan="6" align='center' class="title">합  계 </TD>
            <TD colspan="2" style='text-align:right' class="title"><%=Util.parseDecimal(t_amt1[0])%></TD>
            <TD class="title"></TD>
            <TD colspan="2" style='text-align:right' class="title"><%=Util.parseDecimal(t_amt2[0])%></TD>
            <TD colspan="8" class="title"></TD>
        </TR>
         
	<%	}else{ %>
        <tr> 
          <td colspan="19" align='center'>해당 계약건이 없습니다.</td>
        </tr>
        <% } %>
      </table></td>
  </tr>
</table>
</form>
</body>
</html>
