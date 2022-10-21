<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_ls_hpg.*, acar.car_service.*"%>
<jsp:useBean id="oh_db" scope="page" class="acar.off_ls_hpg.OfflshpgDatabase"/>
<jsp:useBean id="sb_bean" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");	
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");		
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");

	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	//차량정보
	Hashtable offlh = oh_db.getOfflshpgCase("", "", c_id);
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		

//-->
</script>
</head>
<body onLoad="self.focus()">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line>            
            <table border=0 cellspacing=1 width=100%>
        <%	CarServDatabase csd = CarServDatabase.getInstance();
			ServiceBean sb_r [] = csd.getServiceAll(c_id);
			for(int i=0; i<sb_r.length; i++){
				sb_bean = sb_r[i];
				
				ServItem2Bean si_r [] = csd.getServItem2All(sb_bean.getCar_mng_id(), sb_bean.getServ_id());
				String f_item = "";
				String a_item = "";
				for(int j=0; j<si_r.length; j++){
 					si_bean = si_r[j];
					if(j==0) f_item = si_bean.getItem();
					if(j==si_r.length-1){
        	 	   		a_item += si_bean.getItem();
	         	   	}else{
    	     	   		a_item += si_bean.getItem()+",";
        	 	   	}
		       	}
				if(si_r.length==1) 		sb_bean.setRep_cont(f_item);
				else if(si_r.length>1) 	sb_bean.setRep_cont(f_item+"외"+(si_r.length-1)+"건");
				
			%>
                <tr> 
                    <td width=5% align="center"><%=i+1%></td>
                    <td width=10% align="center"><a href="javascript:parent.SetCarServ('<%=sb_bean.getCar_mng_id()%>', '<%=sb_bean.getServ_id()%>', '<%=sb_bean.getOff_nm()%>', '<%=AddUtil.ChangeDate2(sb_bean.getServ_dt())%>','<%=sb_bean.getRep_cont()%>', '<%=Util.parseDecimal(sb_bean.getTot_dist())%>')"><%if(sb_bean.getServ_dt().equals("")){%>미처리<%}else{%><%=AddUtil.ChangeDate2(sb_bean.getServ_dt())%><%}%></a></td>
                    <td width=10% align="center"><%=sb_bean.getServ_st_nm()%></td>
                    <td width=20% align="center"><%=sb_bean.getOff_nm()%></td>
                    <td width=40%>&nbsp;<%=sb_bean.getRep_cont()%></td>
                    <td width=10% align="right"><%=Util.parseDecimal(sb_bean.getTot_amt())%>원</td>					
                    <td width=5% align="center"><a href="javascript:MM_openBrWindow('/acar/cus_reg/serv_reg.jsp?rent_mng_id=<%=sb_bean.getRent_mng_id()%>&rent_l_cd=<%=sb_bean.getRent_l_cd()%>&car_mng_id=<%=sb_bean.getCar_mng_id()%>&accid_id=<%=sb_bean.getAccid_id()%>&serv_id=<%=sb_bean.getServ_id()%>','popwin_loop','scrollbars=yes,status=no,resizable=no,width=850,height=700,top=20,left=20')">[보기]</a></td>										
                </tr>
                <%}
        		 if(sb_r.length == 0) { %>
                <tr> 
                    <td colspan=6 align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
        <%}%>
            </table>
        </td>
    </tr>
	<tr>
	  <td>* 정비일자를 클릭하여 선택하십시오.
	  </td>
	</tr>
</table>
</body>
</html>