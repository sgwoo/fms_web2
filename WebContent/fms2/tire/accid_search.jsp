<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.tire.*, acar.accid.*,acar.util.*"%>

<jsp:useBean id="t_db" scope="page" class="acar.tire.TireDatabase"/>

<%
	

	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
		
	if(s_kd.equals("5")) t_wd = AddUtil.replace(t_wd, "-", "");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	Vector accids = as_db.getAccidSList(br_id, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st);
	int accid_size = accids.size();
	
	
	Vector tire = new Vector();
	int tire_size = 0;
	
	if(!t_wd.equals("")){
//		tire = t_db.getLongRents(t_wd);
		tire = t_db.getRentSearch("", "", "", "", "2", t_wd);
		tire_size = tire.size();
	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="accid_search.jsp";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search();
	}	
	
	function Disp(accid_id) {
		var fm = document.form1;
	
		opener.form1.accid_id.value 		= accid_id;	
		opener.form1.accid_check.value 		= accid_id;	
		window.close();	
	}
//-->
</script>


</head>
<body>
<form action="./accid_search.jsp" name="form1" method="POST">

  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>  
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">  
  <input type="hidden" name="t_wd" value="<%=t_wd%>">  
  <input type="hidden" name="go_url" value="<%=go_url%>">    
 <table border="0" cellspacing="0" cellpadding="0" width='1450'>
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td colspan=2 class=line2>   
                    </td>                    
                </tr>     
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type="radio" name="gubun2" value="2" <%if(gubun2.equals("2"))%>checked<%%>>
                      ��� 
                     <input type="radio"  name="gubun2" value="4" <%if(gubun2.equals("4"))%>checked<%%>>
                     ����              
                      <input type="radio" name="gubun2" value="5" <%if(gubun2.equals("5"))%>checked<%%>>
                      ��ȸ�Ⱓ 		               			
                      <input type="text" name="st_dt" value='<%=st_dt%>' size="9" class="text">
                      ~ 
                      <input type="text" name="end_dt" value='<%=end_dt%>' size="9" class="text">
                    </td>
                    <td >     
                      <a href='javascript:Search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a> 
                    </td>
                </tr>
                  
               
                <tr id='tr_title' style='position:relative;z-index:1'>
            	    <td class='line' width='520' id='td_title' style='position:relative;'> 
            	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>            
                          <tr> 
                            <td width='70' class='title'>����ȣ</td>
                            <td width='50' class='title'>����</td>
                            <td width='70' class='title'>�������</td>
                            <td width='100' class='title'>����ȣ</td>
                            <td width='130' class='title'>��ȣ</td>
                            <td width='90' class='title'>������ȣ</td>
                          </tr>
                        </table>
                    </td>
	                <td class='line' width=930>
	                    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                            <tr> 
                                <td width='150' class='title'>����</td>
                                <td width='120' class='title'>����Ͻ�</td>
                                <td width='120' class='title'>����������ȣ</td>
                                <td width='150' class='title'>������</td>
                                <td width='150' class='title'>�����</td>
                                <td width='100' class='title'>������</td>
                                <td width='100' class='title'>�����</td>
                                <td width='40' class='title'>����</td>
                            </tr>
                        </table>
	                </td>
                </tr>
<%	if(accid_size > 0){%>
                <tr>
            	    <td class='line' width='520' id='td_con' style='position:relative;'> 
                	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                          <% 		for (int i = 0 ; i < accid_size ; i++){
                			Hashtable accid = (Hashtable)accids.elementAt(i);%>
                          <tr> 
                            <td align="center" width='70'> <a href="javascript:Disp('<%=accid.get("ACCID_ID")%>')" onMouseOver="window.status=''; return true"><%=accid.get("ACCID_ID")%></a></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='50' align='center'> 
                              <%if(String.valueOf(accid.get("SETTLE_ST")).equals("1")){%>
                              ���� 
                              <%}else{%>
                              <font color="#FF6600">����</font> 
                              <%}%>
                            </td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='70' align='center'><%=accid.get("ACCID_ST_NM")%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><%=accid.get("RENT_L_CD")%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='130' align='center'> 
                              <%if(accid.get("FIRM_NM").equals("(��)�Ƹ���ī") && !accid.get("CUST_NM").equals("")){%>
                              <span title='(<%=accid.get("RES_ST")%>)<%=accid.get("CUST_NM")%>'><%=Util.subData(String.valueOf(accid.get("CUST_NM")), 5)%></span>	
                              <%}else{%>
                              <span title='<%=accid.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(accid.get("FIRM_NM")), 9)%></span> 
                              <%}%>
                            </td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='90' align='center'><%=accid.get("CAR_NO")%></td>
                          </tr>
                          <%		}%>
                        </table></td>
	                <td class='line' width='930'>
	                    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);
			
				String content_code = "PIC_ACCID";
				String content_seq  = String.valueOf(accid.get("CAR_MNG_ID"))+""+String.valueOf(accid.get("ACCID_ID"));							
			
			%>
                          <tr> 
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='150' align='center'><span title='<%=accid.get("CAR_NM")%> <%=accid.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(accid.get("CAR_NM"))+" "+String.valueOf(accid.get("CAR_NAME")), 12)%></span></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='120' align='center'><%=AddUtil.ChangeDate3(String.valueOf(accid.get("ACCID_DT")))%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='120' align="center"><%=accid.get("OUR_NUM")%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='150'>&nbsp;<span title='<%=accid.get("ACCID_ADDR")%>'><%=Util.subData(String.valueOf(accid.get("ACCID_ADDR")), 11)%></span></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='150'>&nbsp;<span title='<%=accid.get("ACCID_CONT")%> <%=accid.get("ACCID_CONT2")%>'><%=Util.subData(String.valueOf(accid.get("ACCID_CONT"))+" "+String.valueOf(accid.get("ACCID_CONT2")), 11)%></span></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><%=c_db.getNameById(String.valueOf(accid.get("ACC_ID")), "USER")%></td>
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='100' align='center'><%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%></td>                            
                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> width='40' align='center'><%=accid.get("PIC_CNT")%></td>
                          </tr>
          <%		}%>
                        </table>
	                </td>
                </tr>
<%	}else{%>                     
                <tr>
            	  <td class='line' width='520' id='td_con' style='position:relative;'> 
            	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                      <tr> 
                        <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                      </tr>
                    </table></td>
	                <td class='line' width='930'>
        	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                  <tr>
        		  <td>&nbsp;</td>
        		</tr>
        	  </table>
	    </td>
  </tr>
<% 	}%>
</table>
	</td>
  </tr>
    <tr>
      <td>&nbsp;<font color="#666666">* ���� : Y �뿩 / N ���� / '' �̰�</font>&nbsp;</td>
    </tr>
    <tr>
      <td align="right"><a href="javascript:window.close();"  ><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
  </table>
</form>
</body>
</html>

