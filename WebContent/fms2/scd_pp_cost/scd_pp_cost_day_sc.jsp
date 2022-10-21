<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.ext.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	long total_amt1	= 0;

	String go_url = request.getParameter("go_url")==null?"/fms2/scd_pp_cost/scd_pp_cost_day_sc.jsp":request.getParameter("go_url");
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function Search(){
	var fm = document.form1;	
	if(fm.t_wd.value == ''){
		alert('�˻����ڸ� �Է��ϼ���.'); return;
	}
	fm.action = "scd_pp_cost_day_sc.jsp";
	fm.target = "_self";
	fm.submit();
}
function CostCase(rent_mng_id, rent_l_cd, rent_st, gubun2){
	var fm = document.form1;
	fm.rent_mng_id.value = rent_mng_id;
	fm.rent_l_cd.value = rent_l_cd;
	fm.rent_st.value = rent_st;
	fm.r_gubun2.value = gubun2;
	fm.target = "c_foot";
	fm.action = "scd_pp_cost_case_sc.jsp";
	fm.submit();		
}
function PpCostMon(){
	window.open("view_account_pp_cost.jsp?est_dt=<%=t_wd%>&gubun2=<%=gubun2%>", "VIEW_ACCOUNT_PP_COST", "left=50, top=50, width=850, height=300, scrollbars=yes, status=yes");	
}
function go_to_list(){
	var fm = document.form1;	
	<%if(!go_url.equals("")){%>
	fm.action='<%=go_url%>';
	fm.target='_self';
	fm.submit();	
	<%}%>
}
//-->
</script>
</head>
<body>
<form name='form1' action='cash_back_sc.jsp' method='post' target='t_content'>
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='rent_mng_id' value=''>
<input type='hidden' name='rent_l_cd' value=''>
<input type='hidden' name='rent_st' value=''>
<input type='hidden' name='r_gubun2' value=''>
<input type='hidden' name='go_url' value='<%=go_url%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=1000>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>����������</span></td>
	  </tr>
	<%if(go_url.equals("/fms2/scd_pp_cost/scd_pp_cost_mon_sc.jsp")){ %>  
    <tr>
        <td align=right colspan="2"><a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a></td>
    </tr>		  
    <%}%>
    <tr>
	    <td align="right">(���ް�����)</td>
	  </tr>	
	  <tr><td class=line2></td></tr>	  
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='20%'  class='title'>�˻�</td>
            <td>&nbsp;
              <select name="s_kd" id="s_kd">               
                <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>����</option>
                <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>����</option>
              </select>            
              ���� : <input type='text' name='t_wd' size='22' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
              
              &nbsp;&nbsp;&nbsp;
                        ���� : 
              <select name="gubun2" id="gubun2">               
                <option value=''  <%if(gubun2.equals("")){%> selected <%}%>>��ü</option>
                <option value='1' <%if(gubun2.equals("1")){%> selected <%}%>>������</option>
                <option value='2' <%if(gubun2.equals("2")){%> selected <%}%>>���ô뿩��</option>
                <option value='3' <%if(gubun2.equals("3")){%> selected <%}%>>�뿩��</option>
              </select>	
              &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
            </td>
          </tr>
        </table>
      </td>
    </tr> 
    <tr> 
        <td class=h></td>
    </tr>     	
    <%	  	if(!s_kd.equals("") && !t_wd.equals("")){
    
				Vector vt = ae_db.getScdPpCostDayStat(s_kd, t_wd, gubun2);
				int vt_size = vt.size();   
				
	            for (int i = 0 ; i < vt_size ; i++){
		            Hashtable ht = (Hashtable)vt.elementAt(i);	
		            
		            if(s_kd.equals("1")){
		            	total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("EST_AMT")));
		            }else if(s_kd.equals("2")){
		            	total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("RC_AMT")));
		            }
	            }
    %>
    <tr> 
        <td class=h></td>
    </tr>      	
	  <tr><td class=line2></td></tr>	  
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='20%' class='title'><%if(s_kd.equals("1")){%>����<%}else if(s_kd.equals("2")){%>����<%}%>����</td>
            <td width='16%'>&nbsp;<%=AddUtil.ChangeDate2(t_wd)%></td>
            <td width='16%' class='title'>�ݾ�</td>
            <td width='16%'>&nbsp;<%=AddUtil.parseDecimalLong(total_amt1)%></td>
            <td width='16%' class='title'>����(��ȸ����)</td>
            <td>&nbsp;<%=AddUtil.getDate()%></td>
          </tr>
        </table>
      </td>
    </tr> 	        
    <tr> 
        <td class=h></td>
    </tr>      	  	  
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' rowspan='2' class='title'>����</td>
                    <td width='15%' rowspan='2' class='title'>����ȣ</td>
                    <td colspan='3' class='title'>�����</td>
                    <td width='10%' rowspan='2' class='title'>������ȣ</td>
                    <td width='15%' rowspan='2' class='title'><%if(s_kd.equals("1")){%>����<%}else if(s_kd.equals("2")){%>����<%}%>�ݾ�</td>
                </tr>
                <tr>
                    <td width='25%' class='title'>��ȣ</td>
                    <td width='15%' class='title'>����</td>
                    <td width='15%' class='title'>�����/�������</td>
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);	
					      %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><a href="javascript:CostCase('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("RENT_ST")%>','<%=ht.get("GUBUN2")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
                    <td align="center"><%=ht.get("FIRM_NM")%></td>
                    <td align="center"><%=ht.get("CLIENT_NM")%></td>
                    <td align="center"><%=ht.get("ENP_NO")%></td>
                    <td align="center"><%=ht.get("CAR_NO")%></td>
                    <td align="right"><%if(s_kd.equals("1")){%><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("EST_AMT")))%><%}else if(s_kd.equals("2")){%><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("RC_AMT")))%><%}%></td>
                </tr>
		            <%	}%>
                <tr>
                    <td colspan='6' align="center">�հ�</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                </tr>				            
		            <%}%>					      
            </table>
	    </td>
    </tr> 
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
	    <td align="right">
        <input type="button" class="button" id="res_reg" value='���͹ݿ��ݾ�' onclick="javascript:PpCostMon();">
	    </td>
    </tr>            
    <%} %>	  
  </table>
</form>
</body>
</html>