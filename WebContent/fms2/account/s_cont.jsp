<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* "%>
<%@ page import="acar.client.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	
	String s_cnt 		= request.getParameter("s_cnt")==null?"":request.getParameter("s_cnt");
	
	String rr = request.getParameter("rr")==null?"":request.getParameter("rr");  //popup ��û�� ������
		 			
	String t_wd_chk = request.getParameter("t_wd_chk")==null?"N":request.getParameter("t_wd_chk");
	String t_ecar_chk = request.getParameter("t_ecar_chk")==null?"N":request.getParameter("t_ecar_chk");

   String t_ecar = request.getParameter("t_ecar")==null?"N":request.getParameter("t_ecar");
   		 
//   out.println(t_ecar);
   		 
	String incom_dt 		= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int incom_seq			= request.getParameter("incom_seq")==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));
	long incom_amt			= request.getParameter("incom_amt")==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
		
	Vector clients = new Vector();
	int client_size = 0;
			
	if ( t_ecar.equals("Y")) {  //���ź����� ó�� - ������ Ʋ�� 
		clients = al_db.getClientEcarList(s_kd, t_wd, asc, t_wd_chk, t_ecar);
		client_size = clients.size();

	}	else {
		if ( !t_wd.equals("")) {
			clients = al_db.getClientList(s_kd, t_wd, asc, t_wd_chk);
			client_size = clients.size();
		}			
	
	}	
	
	

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
		if(fm.t_ecar_chk.checked){
	      fm.t_ecar.value = 'Y' ;
		} else { 
			if(fm.t_wd.value == ''){ alert('�˻�� �Է��Ͻʽÿ�.'); fm.t_wd.focus(); return; }	
		}	
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
			if(ck.name == "cid"){
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}	
	
		//����ϱ�
	function save(incom_dt, incom_seq, incom_amt, s_kd, t_wd, s_cnt){
		fm = document.form1;
				
		var len=fm.elements.length;
		var cnt=0;
		var cnt1=0;
		var clen=0;
		var idnum="";
		var id="";
				
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "cid"){		
				if(ck.checked == true){
					cnt++;					
					idnum=ck.value;
				}
			}
			
			if(ck.name == "vid"){	
				if(idnum != ""){
				  	if(ck.value == ''){
					    	cnt1++;					    	
					}	
				}
				idnum = "";	
			}		
				
		}	
		
		if(cnt == 0){
		 	alert("�ŷ�ó�� �����ϼ���.");
			return;
		}	
			
		if(cnt1 != 0){
		 	alert("�ŷ�ó�� �׿����ڵ带 Ȯ���ϼ���.");
			return;
		}	
				
		//if(!confirm("�����Ͻðڽ��ϱ�?"))	return;
		
		//��ü���ñ�� �߰��� ��
			
		for(var j=0 ; j<len ; j++){
			var ck=fm.elements[j];		
			if(ck.name == "cid"){		
				if(ck.checked == true){
					id = id  + ck.value + ","
				   
				}
			}
			
		}			
		 
		opener.parent.c_foot.location.href 	= "/fms2/account/incom_reg_scd_step2_sc.jsp?t_ecar_chk="+fm.t_ecar.value + "&rr="+fm.rr.value+"&s_cnt="+s_cnt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&all_cid="+id+"&incom_dt="+incom_dt+"&incom_seq="+incom_seq+"&incom_amt="+incom_amt;		
		
		self.close();
	
	}	
		
//-->
</script>
</head>

<body onload="document.form1.t_wd.focus()">
<form name='form1' method='post' action='s_cont.jsp'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<input type="hidden" name="incom_dt" 			value="<%=incom_dt%>">
<input type="hidden" name="incom_seq" 		value="<%=incom_seq%>">
<input type="hidden" name="incom_amt" 		value="<%=incom_amt%>">
<input type="hidden" name="s_cnt"	value="<%=s_cnt%>">
<input type="hidden" name="rr"	value="<%=rr%>">
<input type="hidden" name="t_ecar"	value="<%=t_ecar%>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>��ȣ</option>
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>��ǥ��</option>
              <option value='3' <%if(s_kd.equals("3"))%>selected<%%>>������ȣ</option>  
           
            </select>
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
            &nbsp;<input type="checkbox" name="t_wd_chk" value='Y' >���þ�ü     
            &nbsp;<input type="checkbox" name="t_ecar_chk" value='Y' >���ź�����     
		    &nbsp;<a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    	
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=4%>����</td>
                    <td class=title width=4%><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>                  
                    <td class=title width=30%>��ȣ</td>
                    <td class=title width=15%>����ڸ�</td>
                    <td class=title width=15%>����</td>    
                    <td class=title width=15%>���뿩</td>     
                    <td class=title width=15%>����Ʈ</td>            
                </tr>
          <%for (int i = 0 ; i < client_size ; i++){
				Hashtable ht = (Hashtable)clients.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><input type="checkbox" name="cid" value="<%=ht.get("CLIENT_ID")%>"></td>
                    <td><input type="hidden" name="vid" value="<%=ht.get("VEN_CODE")%>"><%=ht.get("FIRM_NM")%>&nbsp;(<%=ht.get("VEN_CODE")%>)</td>
                    <td><%=ht.get("CON_AGNT_NM")%></td>
                    <td><%=ht.get("CLIENT_ST_NM")%></td>
                    <td><%=ht.get("L_USE_CNT")%>/<%=ht.get("LT_CNT")%></td>
                    <td><%=ht.get("S_USE_CNT")%>/<%=ht.get("ST_CNT")%></td>
                                          
                </tr>
          <%		}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;<font color=red>*</font>&nbsp;�����ǻ�� ���þ�ü�� �� üũ�ϼ���!!!.</td>
    </tr>	
    
    <tr> 
        <td align="center"><a href="javascript:save('<%=incom_dt%>', '<%=incom_seq%>', '<%=incom_amt%>', '<%=s_kd%>', '<%=t_wd%>', '<%=s_cnt%>');"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a> &nbsp;<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>