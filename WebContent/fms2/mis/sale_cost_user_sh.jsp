<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

		
	int cnt = 3; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-15;//현황 라인수만큼 제한 아이프레임 사이즈

//비용캠페인변수 : cost_campaign 테이블
	Hashtable ht3 = ac_db.getCostCampaignVar2("2");
	
	String year 		= (String)ht3.get("YEAR");
	String tm 			= (String)ht3.get("TM");
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector users = c_db.getUserList("", "", "EMP"); //담당자 리스트	
	int user_size = users.size();	
	Vector users2 = c_db.getUserList("9999", "", "", "N"); //퇴사자 리스트
	int user_size2 = users2.size();
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--

	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8' ){ //영업담당자
			td_input.style.display	= 'none';
			td_bus.style.display	= '';													
															
		}
	}	
			
	function search(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8' ){ //영업담당자or관리담당자
			fm.t_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;		
		}
		fm.submit()
	}		
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}


function ChangeDT(arg)
{
	var theForm = document.form1;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}	

//-->
</script>

</head>
<body>
<form name='form1' action='sale_cost_user_sc.jsp' target='c_body' method='post'>
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type='hidden' name='cs_dt' value='<%=cs_dt%>'>
  <input type='hidden' name='ce_dt' value='<%=ce_dt%>'>    

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 >
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 비용관리 > <span class=style5>사원별영업효율현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>    
    </tr>
    <tr>
        <td class=h></td>
    </tr>
      
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_campaign.gif align=absmiddle>&nbsp;
        <input type="text" name="ref_dt1" size="11" value="<%= AddUtil.ChangeDate2(cs_dt) %>" class=whitetext onBlur='javascript:this.value=ChangeDate(this.value)'>
        ~ 
        <input type="text" name="ref_dt2" size="11" value="<%= AddUtil.ChangeDate2(ce_dt) %>" class=whitetext onBlur='javascript:this.value=ChangeDate(this.value)'></td>      
    </tr>
    
    <tr> 
     <td> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            <tr> 
                    <td width='190'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>
					          &nbsp;&nbsp;&nbsp;&nbsp;<select name='s_kd' onChange="javascript:document.form1.t_wd.value='', cng_input()">
					            <option value='8' <%if(s_kd.equals("8")){%> selected <%}%>>최초영업자</option>
					          </select>
					 </td>
					 <td> 
					                <table width="100%" border="0" cellspacing="0" cellpadding="0">
					                    <tr> 
					                          <td id='td_input' <%if(s_kd.equals("8")){%> style='display:none'<%}%>> 
					                            <input type='text' name='t_wd' size='12' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()'>
					                          </td>
					                          <td id='td_bus' <%if(s_kd.equals("8")){%> style="display:''"<%}else{%>style='display:none'<%}%>> 
					                            <select name='s_bus' onChange='javascript:search();'>
					                              <option value="">전체</option>
					                              <%	if(user_size > 0){
					        						for (int i = 0 ; i < user_size ; i++){
					        							Hashtable user = (Hashtable)users.elementAt(i);	%>
					                              <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
					                              <%		}
					        					}		%>
					        					
					        		  <option value="">=퇴사자=</option>
					                  <%if(user_size2 > 0){
					        				for (int i = 0 ; i < user_size2 ; i++){
					        					Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
					                  <option value='<%=user2.get("USER_ID")%>' <%if(t_wd.equals(user2.get("USER_ID"))) out.println("selected");%>><%=user2.get("USER_NM")%></option>
					                  <%	}
					        			}%>
														
					                            </select>
					                          </td>
					                   					  
					                    </tr>
					                </table>
					 </td>
					 <td align='right'><a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a> 
					 </td>
		    </tr>
		    </table>
	  </td>	     			 
    </tr>  
  
  </table>
  </form>
  <iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</table>
</body>