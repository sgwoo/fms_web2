<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.off_ls_hpg.*, acar.car_service.*"%>
<jsp:useBean id="oh_db" scope="session" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<jsp:useBean id="sb_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>

<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	//차량정보
	Hashtable secondhand = oh_db.getSecondhandCase("", "", c_id);
	
	int rent_way_chk = oh_db.getContRentWay(c_id);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>::: 정비 기록표 :::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="/acar/main_car_hp/style_est.css" rel="stylesheet" type="text/css">
<style type=text/css>
<!--
.style1 {color: #859f00}
.style2 {color: #595959}
.style3 {color: #5d93a0}
.style4 {color: #ef620c}
.style5 {color: #2f268a;
         font-size: 11px;} 
-->
</style>

</head>

<body topmargin=0 leftmargin=0>
<table width=603 border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td height=54 align=center><img src=/acar/main_car_hp/images/pop_rep_title.gif></td>
    </tr>
    <tr>
        <td height=10></td>
    </tr>
    <tr>
        <td height=30>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/main_car_hp/images/pop_car_arrow.gif>
        <span class=style2><b> <%=secondhand.get("CAR_NO")%></b></span></td>
    </tr>
    <%if(from_page.equals("/fms2/lc_rent/lc_b_s.jsp") && !String.valueOf(secondhand.get("DIST_CNG")).equals("")){%>
    <tr>
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* <%=secondhand.get("DIST_CNG")%></td>
    </tr>
    <%}%>    
    <tr>
        <td align=center>
          <table width=568 border=0 cellpadding=0 cellspacing=1 bgcolor=bad4d4>
				<tr align=center bgcolor=e1ecec>
					<td width=32 height=43><img src=/acar/main_car_hp/images/pop_rep_t1.gif width=14 height=9></td>
					<td width=81><img src=/acar/main_car_hp/images/pop_rep_t2.gif width=37 height=11></td>
					<td width=68><img src=/acar/main_car_hp/images/pop_rep_t3.gif width=37 height=11></td>
			
					<td width=152><img src=/acar/main_car_hp/images/pop_rep_t5.gif width=36 height=11></td>
					<td width=82><img src=/acar/main_car_hp/images/pop_rep_t6.gif width=36 height=11></td>
					<td width=80><img src=/acar/main_car_hp/images/pop_rep_t7.gif width=37 height=11></td>
				</tr>
				<%CarServDatabase csd = CarServDatabase.getInstance();
		ServiceBean sb_r [] = csd.getServiceAll(c_id);
		for(int i=0; i<sb_r.length; i++){
			sb_bean = sb_r[i];%>
				<tr>
					<td height=39 align=center bgcolor=eef7f7><span class=style3><%=i+1%></span></td>
					<td align=center bgcolor=#FFFFFF><span class=style2>&nbsp;<span class=style2><%=AddUtil.ChangeDate2(sb_bean.getServ_dt())%></span>&nbsp;</span></td>
					<td align=center bgcolor=#FFFFFF><span class=style1>&nbsp;<%=sb_bean.getServ_st_nm()%>&nbsp;</span>
					
					</td>
				
					<td align=center bgcolor=#FFFFFF><span class=style2>&nbsp;<%=sb_bean.getOff_nm()%>&nbsp;</span></td>
					<td align=center bgcolor=#FFFFFF><span class=style2>&nbsp;
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
					&nbsp;</span>
					<%if(!sb_bean.getReg_dt().equals("") && from_page.equals("/fms2/lc_rent/lc_b_s.jsp")){%>
					<font color=#CCCCCC><br>(등록일:<%=sb_bean.getReg_dt()%>)</font>
					<%}%>
					</td>
					<td align=right bgcolor=#FFFFFF><span class=style2>&nbsp;<%=Util.parseDecimal(sb_bean.getTot_dist())%>km</span>&nbsp;</td>
				</tr>
				<%}
		 		if(sb_r.length == 0) { %>
				<tr>
					<td height="30" colspan="7" bgcolor=#FFFFFF align=center><span class=style1>정비 기록이 없습니다.</span></td>
				</tr>
				<%}%>
			</table>
		</td>
    </tr>
	<%if(from_page.equals("/fms2/lc_rent/lc_b_s.jsp")){
			ServiceBean sb_r2 [] = csd.getServiceAll_OtherDist(c_id);
			if(sb_r2.length>0){%>
    <tr>
        <td align=center>
          <table width=568 border=0 cellpadding=0 cellspacing=1 bgcolor=bad4d4>
				<tr align=center bgcolor=e1ecec>
					<td width=32 height=43><img src=/acar/main_car_hp/images/pop_rep_t1.gif width=14 height=9></td>
					<td width=81><img src=/acar/main_car_hp/images/pop_rep_t2.gif width=37 height=11></td>
					<td width=68><img src=/acar/main_car_hp/images/pop_rep_t3.gif width=37 height=11></td>
					<td width=65><img src=/acar/main_car_hp/images/pop_rep_t4.gif width=28 height=11></td>
					<td width=152><img src=/acar/main_car_hp/images/pop_rep_t5.gif width=36 height=11></td>
					<td width=82><img src=/acar/main_car_hp/images/pop_rep_t6.gif width=36 height=11></td>
					<td width=80><img src=/acar/main_car_hp/images/pop_rep_t7.gif width=37 height=11></td>
				</tr>
				<%for(int i=0; i<sb_r2.length; i++){
					sb_bean = sb_r2[i];%>
				<tr>
					<td height=39 align=center bgcolor=eef7f7><span class=style3><%=i+1%></span></td>
					<td align=center bgcolor=#FFFFFF><span class=style2>&nbsp;<span class=style2><%=AddUtil.ChangeDate2(sb_bean.getServ_dt())%></span>&nbsp;</span></td>
					<td align=center bgcolor=#FFFFFF><span class=style1>&nbsp;<%//=sb_bean.getServ_st_nm()%>&nbsp;</span></td>
					<td align=center bgcolor=#FFFFFF><span class=style2>&nbsp;<%//=sb_bean.getChecker()%>&nbsp;</span></td>
					<td align=center bgcolor=#FFFFFF><span class=style2>&nbsp;<%=sb_bean.getOff_nm()%>&nbsp;</span></td>
					<td align=center bgcolor=#FFFFFF><span class=style2>&nbsp;
					<%if(!sb_bean.getReg_dt().equals("") && from_page.equals("/fms2/lc_rent/lc_b_s.jsp")){%>
					<font color=#CCCCCC>등록일:<br><%=sb_bean.getReg_dt()%></font>
					<%}%>
					<%//=sb_bean.getRep_cont()%>&nbsp;</span></td>
					<td align=right bgcolor=#FFFFFF><span class=style2>&nbsp;<%=Util.parseDecimal(sb_bean.getTot_dist())%>km</span>&nbsp;</td>
				</tr>
				<%}%>
			</table>
		</td>
    </tr>	
	<%		}%>
	<%}%>	
	<%if(rent_way_chk >0){%>
	<tr>
	    <td height=7></td>
	</tr>
	<tr>
	  <td height="16"><span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* 당 차량은 기본식(고객이 직접 정비)으로 운행된 차량으로 위 순회점검 이전 상세정비에 관한 기록이 표기되지</span>
	  </td>
	</tr>
	<tr>
	  <td height="16"><span class=style5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;않았음을 알려드립니다</span>
	  </td>
	</tr>
	<%}%>
	<tr>
		<td height="35" align=right><img src=/acar/main_car_hp/images/pop_car_img.gif>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>
    <tr> 
    	<td height="50" class="TableSUB"><div align="center"><a href="javascript:self.close()"><img src="/acar/main_car_hp/images/off-clossbutton.gif" width="58" height="24" border="0"></a></div></td>
  	</tr>
</table>


</body>
</html>
