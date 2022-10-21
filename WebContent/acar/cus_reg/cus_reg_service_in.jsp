<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*, acar.car_service.*, acar.user_mng.*" %>
<jsp:useBean id="si_bean" class="acar.car_service.ServItem2Bean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	CusReg_Database cr_db = CusReg_Database.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	CarServDatabase csd = CarServDatabase.getInstance();

	ServInfoBean[] siBns = cr_db.getServiceAll(car_mng_id);
	ServInfoBean siBn = new ServInfoBean();
		
	long tot_amt = csd.getTot_amt(car_mng_id);
	
	long tot_amt1	= 0;
			tot_amt1 = csd.getServ_amt(car_mng_id, "1");
	long tot_amt2	= 0;
			tot_amt2 = csd.getServ_amt(car_mng_id, "2");
	long tot_amt3	= 0;
			tot_amt3 = csd.getServ_amt(car_mng_id, "3");
	long tot_amt4	= 0;
			tot_amt4 = csd.getServ_amt(car_mng_id, "4");
	long tot_amt5	= 0;
			tot_amt5 = csd.getServ_amt(car_mng_id, "5");
	long tot_amt7	= 0;
			tot_amt7 = csd.getServ_amt(car_mng_id, "7");
	long tot_amt9	= 0;
			tot_amt9 = csd.getServ_amt(car_mng_id, "9");
	long tot_amt12	= 0;
			tot_amt12 = csd.getServ_amt(car_mng_id, "12");			
	long tot_amt13	= 0;
			tot_amt13 = csd.getServ_amt(car_mng_id, "13");			
	
	String dept_id = login.getDept_id(ck_acar_id);
	String serv_st = "";
	String serv_amt = "";
	
	String mng_mode = ""; 
	if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("�����������",ck_acar_id)){
		mng_mode = "A";
	}
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
//���� ��� �˾������� ����
function serv_reg(car_mng_id, serv_id, accid_id){
<%		if(!dept_id.equals("8888")){%>	
	var SUBWIN="serv_reg.jsp?car_mng_id=" + car_mng_id + "&serv_id=" + serv_id+"&accid_id="+accid_id; 
<%		}else{%>	
	var SUBWIN="serv_accid_reg.jsp?car_mng_id=" + car_mng_id + "&serv_id=" + serv_id+"&accid_id="+accid_id; 
<%		}%>	
	window.open(SUBWIN, 'popwin_serv_reg','scrollbars=yes,status=yes,resizable=yes,width=900,height=720,top=50,left=50');
}	

function display(serv_st){
  var serv_amt = document.getElementById("serv_amt");
		if(serv_st == '1'){
			serv_amt.value = "<%=AddUtil.parseDecimal(tot_amt1) %>"+"��"
        }else if(serv_st == '2'){
    		serv_amt.value = "<%=AddUtil.parseDecimal(tot_amt2) %>"+"��"
        }else if(serv_st == '3'){
        	serv_amt.value = "<%=AddUtil.parseDecimal(tot_amt3) %>"+"��"
        }else if(serv_st == '4'){
	        serv_amt.value = "<%=AddUtil.parseDecimal(tot_amt4) %>"+"��"
        }else if(serv_st == '5'){
	        serv_amt.value = "<%=AddUtil.parseDecimal(tot_amt5) %>"+"��"
        }else if(serv_st == '7'){
	        serv_amt.value = "<%=AddUtil.parseDecimal(tot_amt7) %>"+"��"
        }else if(serv_st == '9'){
	        serv_amt.value = "<%=AddUtil.parseDecimal(tot_amt9) %>"+"��"
		}else if(serv_st == '12'){
	        serv_amt.value = "<%=AddUtil.parseDecimal(tot_amt12) %>"+"��"
		}else if(serv_st == '13'){
	        serv_amt.value = "<%=AddUtil.parseDecimal(tot_amt13) %>"+"��"
        }else{
	        serv_amt.value = "<%=AddUtil.parseDecimal(tot_amt) %>"+"��"
        }
 }
//-->
</script>
</head>

<body>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="car_mng_id" value="<%= car_mng_id %>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%	for(int i=0; i<siBns.length; i++){
		siBn = siBns[i];
		
		ServItem2Bean si_r [] = csd.getServItem2All(siBn.getCar_mng_id(), siBn.getServ_id());
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
		%>
        <tr> 
       
          <td <%if(siBn.getServ_st().equals("")){%> <%}else{%>class="is"<%}%> width=4% align='center'><%= i+1 %></td>
          <td <%if(siBn.getServ_st().equals("")){%> <%}else{%>class="is"<%}%> width=9% align="center"><%= AddUtil.ChangeDate2(siBn.getNext_serv_dt()) %></td>
          <td <%if(siBn.getServ_st().equals("")){%> <%}else{%>class="is"<%}%> width=9% align="center">
		    <%	if(siBn.getServ_dt().equals("")){%>
			  	<%= AddUtil.ChangeDate2(siBn.getSpdchk_dt()) %>
			<% 	}else{ %>
				<%= AddUtil.ChangeDate2(siBn.getServ_dt()) %>
			<% 	} %></td>
          <td <%if(siBn.getServ_st().equals("")){%> <%}else{%>class="is"<%}%> align="center" width=7%>
		    <%	if(!siBn.getChecker().equals("")){
					if(siBn.getChecker().substring(0,2).equals("00")){%>
					<%= login.getAcarName2(siBn.getChecker()) %>
			<%		}else{%>
					<%= siBn.getChecker() %>
			<%		}
			  	}%></td>
          <td <%if(siBn.getServ_st().equals("")){%> <%}else{%>class="is"<%}%>  align="center" width=7%>
		    <%	if(siBn.getChecker_st().equals("1")) 		out.print("������");
		  		else if(siBn.getChecker_st().equals("2")) 	out.print("��������");
				else if(siBn.getChecker_st().equals("3")) 	out.print("��");
				else 										out.print("-"); %></td>
          <td <%if(siBn.getServ_st().equals("")){%> <%}else{%>class="is"<%}%>  width=9% align="center">
		    <% 	if(siBn.getServ_st().equals("8")||siBn.getServ_st().equals("9")||siBn.getServ_st().equals("10")){ %>
				<%=siBn.getServ_st_nm()%>
			<% 	}else{ %>			  	
				<a href="javascript:serv_reg('<%= car_mng_id %>','<%=siBn.getServ_id()%>','<%=siBn.getAccid_id()%>')"><%=siBn.getServ_st_nm()%><%if(siBn.getServ_st().equals("")){%>��ȸ����<%}%></a> 
			<% 	} %></td>
          <td <%if(siBn.getServ_st().equals("")){%> <%}else{%>class="is"<%}%> width=9% align="center">
		    <%	if(siBn.getServ_jc().equals("1")) 			out.print("����"); 
				else if(siBn.getServ_jc().equals("2"))		out.print("����û");
				else										out.print("");%></td>
          <td <%if(siBn.getServ_st().equals("")){%> <%}else{%>class="is"<%}%> width=17%>
		    <% 	if(!siBn.getServ_dt().equals("")){ 
			  		if((siBn.getServ_st().equals("2")||siBn.getServ_st().equals("3"))&&(AddUtil.parseInt(siBn.getServ_dt())>20031231)&&!siBn.getSpd_chk().equals("")){ %>
			  	&nbsp;<a href="javascript:serv_reg('<%= car_mng_id %>','<%=siBn.getServ_id()%>','<%=siBn.getAccid_id()%>')">[��ȸ]</a>              
            <%		}
			  	} %>
			<%	if(!a_item.equals("")){%>
				<span title="<%=a_item%>">										
			<%	}else{%>
				<span title="<%=siBn.getRep_cont()%>">
			<%	}%> 
            <%	if(!a_item.equals("")){%>
						&nbsp;<%=f_item%><% if(si_r.length>1){ %>�� <font color="red"><%=si_r.length-1%></font>�� <% } %>
			<%	}else{%>
					&nbsp;<%=Util.subData(siBn.getRep_cont(),10)%>		
			<%  } %>
              </span>
		  </td>
          <td <%if(siBn.getServ_st().equals("")){%> <%}else{%>class="is"<%}%> width=8% align="right"><%=Util.parseDecimal(siBn.getTot_dist())%>km&nbsp;</td>
          <td <%if(siBn.getServ_st().equals("")){%> <%}else{%>class="is"<%}%> width=7% align="right"><%=Util.parseDecimal(siBn.getTot_amt())%>��&nbsp;</td>
          <td <%if(siBn.getServ_st().equals("")){%> <%}else{%>class="is"<%}%> width=7% align="center">
		    <%	if(siBn.getServ_st().equals("8")||siBn.getServ_st().equals("9")||siBn.getServ_st().equals("10")){ %>
				-
			<% 	}else{ %>
						
			   <% if ( !siBn.getRep_cont().equals("��å�� ��û����")  && !siBn.getOff_id().equals("008634")  ) { %>	
				<a href="javascript:serv_reg('<%= siBn.getCar_mng_id() %>','<%= siBn.getServ_id() %>','<%=siBn.getAccid_id()%>')"><% if(siBn.getChecker().equals("")){ %><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0><% }else{ %><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0><% } %></a>
			   <% } %>
			<% 	} %>
		  </td>
          <td <%if(siBn.getServ_st().equals("")){%> <%}else{%>class="is"<%}%> width=7% align="center">
		    <% 	if(siBn.getServ_st().equals("8")||siBn.getServ_st().equals("9")||siBn.getServ_st().equals("10")){ %>
				-
			<% 	}else{ %>
			<%	 	if( siBn.getServ_st().equals("") ||  siBn.getReg_id().equals(ck_acar_id) || siBn.getChecker().equals(ck_acar_id) || mng_mode.equals("A") ){ %>
			<%			if( siBn.getJung_st().equals("") && !siBn.getSac_yn().equals("Y") ) { //Ƽ�̾���Ÿ���� ����� ���� �Ұ�  %>
			<%             if (  !siBn.getOff_id().equals("008634")   ){ //Ƽ�̾���Ÿ���� ����� ���� �Ұ�  %>
				<a href="javascript:parent.deleteScdServ('<%= siBn.getServ_id() %>')"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a>
				<%			}%>				
			<%			}%>
			<% 		} %>
			<% 	} %>
		  </td>
        </tr>
<%}%>
		<tr> 
	        <td class='title' width=4%></td>
	        <td class='title' width=9%></td>
	        <td class='title' width=9%></td>
	        <td class='title' width=7%></td>
	        <td class='title' width=7%></td>
	        <td class='title' width=9%></td>
	        <td class='title' width=9%></td>
	         <td class='title' width=17%>
		        <SELECT NAME="serv_st" onChange="display(this.value);"> 
					<OPTION VALUE="" selected >��ü ����� ���հ�</OPTION>
					<OPTION VALUE="1" >��ȸ���� ���հ�</OPTION>
					<OPTION VALUE="2" >�Ϲ����� ���հ�</OPTION>
					<OPTION VALUE="3" >�������� ���հ�</OPTION>
					<OPTION VALUE="12" >�������� ���հ�</OPTION>
					<OPTION VALUE="13" >���� ���հ�</OPTION>
					<OPTION VALUE="7" >�縮������ ���հ�</OPTION>
					<OPTION VALUE="9" >�������� ���հ�</OPTION>
			    </SELECT>
	        </td>
			<td class='title' colspan="2" width=7% style="text-align:right" >
			<input type="text" id="serv_amt" class="num" value="<%= AddUtil.parseDecimal(tot_amt) %>��" >
			</td>
	        <td class='title' width=7%></td>
	        <td class='title' width=7%></td>
	    </tr>
	<%if(siBns.length == 0) { %>
        <tr> 
          <td colspan="12" align='center'>�ش� �ڵ��� ���� �������� �����ϴ�.</td>
        </tr>
<%	}%>
      </table>
	</td>
  </tr>
</table>
</form>
</body>
</html>
