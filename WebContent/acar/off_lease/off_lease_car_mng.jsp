<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_service.*, acar.common.*" %>
<jsp:useBean id="sb_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	CarServDatabase csd = CarServDatabase.getInstance();	
	ServiceBean sb_r [] = csd.getServiceAll(car_mng_id);	
	
	LoginBean login = LoginBean.getInstance();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	function pop_excel(){
		var fm = document.form1;
		fm.target = "_blak";
		fm.action = "/acar/cus0401/popup_excel.jsp";
		fm.submit();
	}	
//-->
</script>
</head>
<body>
<form name="form1" method="post">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td colspan="3"> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
		        <tr>
		            <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>정비기록표</span></td> 
		            <td align="right">
		            <a href="javascript:pop_excel();"><img src=../images/center/button_excel.gif border=0 align=absmiddle></a>
		            </td>
		        </tr>
		        <tr>
		            <td class=line2 colspan=2></td>
		        </tr>
                <tr> 
                    <td class='line' colspan=2> 
                        <table  border=0 cellspacing=1 width=100%>
                            <tr>
                                <td width=5% class=title>연번</td>
                                <td width=11% class=title>정비일자</td>
                                <td width=10% class=title>정비구분</td>
                                <td width=10% class=title>담당자</td>
                                <td width=20% class=title>정비업체</td>
                                <td width=34% class=title>점검내용</td>
                                <td width=10% class=title>주행거리</td>
                            </tr>
                        </table>
                    </td>          
                </tr>
            </table>
        </td>
    </tr>
    <tr>
		<td class='line'>			 
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <%for(int i=0; i<sb_r.length; i++){
        				sb_bean = sb_r[i];%>
                <tr> 
                    <td width=5% align=center><%=i+1%></td>
                    <td width=11% align=center><%if(!sb_bean.getServ_dt().equals("")){%>
        		  								<%= AddUtil.ChangeDate2(sb_bean.getServ_dt()) %>
        										<%}%></td>
                    <td width=10% align=center><%            String serv_st = sb_bean.getServ_st();
        		  								String accid_st = c_db.getAccid_st(car_mng_id,sb_bean.getAccid_id());
        										//if(serv_st.equals("1")||serv_st.equals("2")||serv_st.equals("3")){%>
        			  								<%=sb_bean.getServ_st_nm()%>
        									<%// }else{//4 사고수리
        										//	if(accid_st.equals("1")){
        										//		out.print("사고수리");
        										//	}else if(accid_st.equals("2")){
        										//		out.print("사고수리");
        										//	}else if(accid_st.equals("3")){
        										//		out.print("사고수리");
        										//	}else if(accid_st.equals("4")){
        										//		out.print("운행자차");
        										//	}else if(accid_st.equals("5")){
        										//		out.print("사고자차");
        										//	}else if(accid_st.equals("12")){
        										//		out.print("해지수리");	
										//	}else if(accid_st.equals("7")){
        										//		out.print("재리스수리");
        										//	}
        								//	} 
        									%></td>
                    <td width=10% align=center><%if(!sb_bean.getChecker().equals("")){
        		  								if(sb_bean.getChecker().substring(0,2).equals("00")){%>
        										<%= login.getAcarName2(sb_bean.getChecker()) %>
        									<%}else{%>
        										<%= sb_bean.getChecker() %>
        									<% }
        									} %></td>
                    <td width=20% align=left>&nbsp;<span title="<%=sb_bean.getOff_nm()%>"><%=Util.subData(sb_bean.getOff_nm(),10)%></span></td>
                    <td width=34% align=center>
                        <table width=100%% border=0 cellspacing=0 cellpadding=3>
                            <tr>
                                <td>
                    		      <%if((sb_bean.getServ_st().equals("2")||sb_bean.getServ_st().equals("3")||sb_bean.getServ_st().equals("4")||sb_bean.getServ_st().equals("7"))&&(AddUtil.parseInt(sb_bean.getServ_dt())>20031231)){
                    					ServItem2Bean si_r [] = csd.getServItem2All(sb_bean.getCar_mng_id(), sb_bean.getServ_id());
                    					for(int j=0; j<si_r.length; j++){
                    						si_bean = si_r[j];
                    						if(j==si_r.length-1){
                    							out.print(si_bean.getItem());
                    						}else{
                    							out.print(si_bean.getItem()+",");
                    						}            	
                    					}										
                    				}else{%>
                    					<%=sb_bean.getRep_cont()%>		
                    			<%  } %>
                    			</td>
                            </tr>
                        </table>
                    </td>
                    <td width=10% align=right><%=Util.parseDecimal(sb_bean.getTot_dist())%> 
                    km&nbsp;</td>
                </tr>
                <%}%>
                <% if(sb_r.length == 0) { %>
                <tr> 
                  <td colspan="7" align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>