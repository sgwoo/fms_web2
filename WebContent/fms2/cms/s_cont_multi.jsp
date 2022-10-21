<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.accid.*, tax.*"%>
<jsp:useBean id="ClientMngDb" scope="page" class="tax.ClientMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String memo_st = request.getParameter("memo_st")==null?"":request.getParameter("memo_st");
	
	String m_chk = request.getParameter("m_chk")==null?"":request.getParameter("m_chk"); //����Ʈ�� ���� �˻� 
		
	if(go_url.equals("/fms2/lc_rent/lc_cng_client_c.jsp") || go_url.equals("/fms2/lc_rent/lc_cng_car_c.jsp")){
		//if(s_kd.equals("1")) s_kd = "7";
		//if(s_kd.equals("2")) s_kd = "8";
	}
	
	if ( m_chk.equals("Y") ) {
		if(s_kd.equals("1")) s_kd = "5";
		if(s_kd.equals("2")) s_kd = "6";
	
	}
	
	Vector accids = ClientMngDb.getRentListSearch(s_br, s_kd, t_wd);
	int accid_size = accids.size();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('�˻�� �Է��Ͻʽÿ�.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	
			//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "rld"){
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}	
		
	//�Ƿ� ���õȰ��� ����� �ŷ�����  ���õ� ��� ó���Ұ� 
	function reg(){
		var fm= document.form1;	
	
		var len=fm.elements.length;	
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "rld"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("����� �����ϼ���.");
			return;
		}	
				
		fm.target = "c_foot";
		fm.action = "cms_reg_etc_sc.jsp" ;		
		fm.submit();
		window.close();
	}			
	
	
//-->
</script>
</head>

<body onload="document.form1.t_wd.focus()">
<form name='form1' method='post' action='s_cont_multi.jsp'>
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
 <input type='hidden' name='go_url' value='<%=go_url%>'> 
 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
              <select name='s_kd'>
<%if(go_url.equals("/fms2/cls_cont/lc_cls_rm_c.jsp") || go_url.equals("/fms2/lc_rent/lc_renew_c_rm.jsp") || go_url.equals("/fms2/lc_rent/lc_im_renew_c_rm.jsp")){%>   
              <option value='5' <%if(s_kd.equals("5"))%>selected<%%>>��ȣ</option>
              <option value='6' <%if(s_kd.equals("6"))%>selected<%%>>������ȣ</option>            
<%} else if(go_url.equals("/acar/accid_mng/upd_l_cd.jsp") ){%>   
                    <option value='9' <%if(s_kd.equals("9"))%>selected<%%>>������ȣ</option>              
              
<%//}else if(go_url.equals("/fms2/lc_rent/lc_cng_client_c.jsp") || go_url.equals("/fms2/lc_rent/lc_cng_car_c.jsp")){%>
<!--              <option value='7' <%if(s_kd.equals("7"))%>selected<%%>>��ȣ</option>
              <option value='8' <%if(s_kd.equals("8"))%>selected<%%>>������ȣ</option>-->
<% } else { %>         
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>��ȣ</option>
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>������ȣ</option>
              <option value='3' <%if(s_kd.equals("3"))%>selected<%%>>�����ȣ</option>			  
              <option value='4' <%if(s_kd.equals("4"))%>selected<%%>>����ȣ</option>	
              <option value='11' <%if(s_kd.equals("11"))%>selected<%%>>����ڹ�ȣ</option>	
<% }%>             
    </select> 
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
		    <a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=5%>����</td>
                    
                    <td class=title width=5%>����</td>
                    <td class=title width=4%><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>            
                    <td class=title width=12%>����ȣ</td>
                    <td class=title width=16%>��ȣ</td>
                    <td class=title width=10%>������ȣ</td>
                    <td class=title width=15%>����</td>			
                    <td class=title width=17%>���Ⱓ</td>
                    <td class=title width=8%>�����</td>
                    <td class=title width=12%>��������</td>
                </tr>
          <%for (int i = 0 ; i < accid_size ; i++){
				Hashtable accid = (Hashtable)accids.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td> 
                      <%if(accid.get("USE_YN").equals("Y")){%>
                      �뿩 
                      <%}else if(accid.get("USE_YN").equals("N")){%>
        			  ����
                      <%}else{%>
                      �̰�
                      <%}%>
                    </td>
                    <td><input type="checkbox" name="rld" value="<%=accid.get("RENT_MNG_ID")%>^<%=accid.get("RENT_L_CD")%>^<%=accid.get("CLIENT_ID")%>^"></td>
                    <td>						
						<%=accid.get("RENT_L_CD")%>
						</td>
                    <td><%=accid.get("FIRM_NM")%>(<%=accid.get("CLIENT_ID")%>)</td>
                    <td><%=accid.get("CAR_NO")%></td>
                    <td><%=accid.get("CAR_NM")%></td>			
                    <td><%=AddUtil.ChangeDate2(String.valueOf(accid.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(accid.get("RENT_END_DT")))%></td>
                     <td><%=c_db.getNameByUserId(String.valueOf(accid.get("BUS_ID2")), "name")%></td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(accid.get("CLS_DT")))%></td>
                </tr>
          <%		}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>	
    <tr> 
        <td align="center">
        <a href="javascript:reg();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>  
        &nbsp;&nbsp;
        <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
       
    </tr>
</table>
</form>
</body>
</html>