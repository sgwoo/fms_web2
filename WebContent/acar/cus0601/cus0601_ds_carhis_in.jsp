<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_service.*" %>
<jsp:useBean id="sb_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
	CarServDatabase csd = CarServDatabase.getInstance();	

	ServiceBean sb_r [] = csd.getServiceAll_off_id(car_mng_id, off_id);
	long tot_amt = csd.getTot_amt(car_mng_id);
	
	LoginBean login = LoginBean.getInstance();	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--

//-->
</script>
</head>

<body>
<form action="0601_carhis_in.jsp" name="LoadServiceForm" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="line">
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
          <%for(int i=0; i<sb_r.length; i++){
				sb_bean = sb_r[i];%>
                <tr> 
                    <td width=5% align=center><%= i+1 %></td>
                    <td width=11% align=center><%=AddUtil.ChangeDate2(sb_bean.getServ_dt())%></td>
                    <td width=11% align=center><%=sb_bean.getServ_st_nm()%></td>
                    <td width=9% align=center><%if(!sb_bean.getChecker().equals("")){
        													if(sb_bean.getChecker().substring(0,2).equals("00")){%> <%= login.getAcarName(sb_bean.getChecker()) %> <%}else{%> <%= sb_bean.getChecker() %> <% }
        												}%> </td>
                    <td width=21%>&nbsp;&nbsp;<span title="<%=sb_bean.getOff_nm()%>"><%=Util.subData(sb_bean.getOff_nm(),10)%></span></td>
                    <td width=33% align=left> <% if(!sb_bean.getServ_dt().equals("")){ 
        			  		if((sb_bean.getServ_st().equals("2")||sb_bean.getServ_st().equals("3"))&&(Integer.parseInt(sb_bean.getServ_dt())>20031231)){ %> <a href="javascript:ServiceDisp('<%=sb_bean.getServ_id()%>','1')">[순회점검]</a> 
                      <% 	}else if(sb_bean.getServ_st().equals("")){%> <a href="javascript:ServiceDisp('','1')">[정비중...]</a> 
                      <%}
        			  } %> &nbsp;<span title="<%if(sb_bean.getServ_st().equals("2")||sb_bean.getServ_st().equals("3")||sb_bean.getServ_st().equals("4")){
                    							ServItem2Bean si_r [] = csd.getServItem2All(sb_bean.getCar_mng_id(), sb_bean.getServ_id());
                    							for(int j=0; j<si_r.length; j++){
        		            						si_bean = si_r[j];
        				    						if(j==si_r.length-1){
                    									out.print(si_bean.getItem());
                    								}else{
                    									out.print(si_bean.getItem()+",");
                    								}            	
                    							}										
                    						}else if(sb_bean.getServ_st().equals("1")){
        										//out.print(AddUtil.subData(sb_bean.getRep_cont(),16));
        									}%>"> 
                      <%if(sb_bean.getServ_st().equals("2")||sb_bean.getServ_st().equals("3")||sb_bean.getServ_st().equals("4")){
                    					ServItem2Bean si_r [] = csd.getServItem2All(sb_bean.getCar_mng_id(), sb_bean.getServ_id());
                    					for(int j=0; j<si_r.length; j++){
                    						si_bean = si_r[j];
                    						if(j==0){
        						%>
                      <%=si_bean.getItem()%> 외 <font color="red"><%=si_r.length-1%></font> 건 
                      <%        	}
                    					}
           				}else if(sb_bean.getServ_st().equals("1")){
        					//out.print(AddUtil.subData(sb_bean.getRep_cont(),16));
        				}%>
                      </span> </td>
                    <td width=10% align=right><%=Util.parseDecimal(sb_bean.getTot_dist())%> km&nbsp;</td>
                </tr>
          <%}%>
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title" align="right">정비비합계</td>
                    <td class="title"><%= AddUtil.parseDecimal(tot_amt) %>&nbsp;원</td>
                    <td class="title">&nbsp;</td>
                </tr>
          <% if(sb_r.length == 0) { %>
                <tr> 
                    <td align=center height=25 colspan="7">등록된 데이타가 없습니다.</td>
                </tr>
          <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
