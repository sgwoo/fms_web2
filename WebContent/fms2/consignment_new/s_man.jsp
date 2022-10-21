<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.consignment.*, acar.cont.*"%>
<jsp:useBean id="cons_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%//@ include file="/acar/cookies.jsp" %> 

<%
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String st 		= request.getParameter("st")==null?"":request.getParameter("st");
	String value 		= request.getParameter("value")==null?"":request.getParameter("value");
	String idx 		= request.getParameter("idx")==null?"":request.getParameter("idx");
	String size		= request.getParameter("size")==null?"0":request.getParameter("size");
	String cons_dt		= request.getParameter("cons_dt")==null?"0":request.getParameter("cons_dt");
	
	String rent_mng_id	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_no		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	
	
	Vector vt = new Vector();
	if(value.equals("1")){
		vt = cons_db.getManSearch1("", s_kd, t_wd);
	}
	if(value.equals("4")){
		vt = cons_db.getManSearch4("", s_kd, t_wd, cons_dt);
	}
	if(value.equals("2") && !t_wd.equals("")){//��
		vt = cons_db.getManSearch2("", s_kd, t_wd, rent_l_cd);
	}
	if(value.equals("3") && !t_wd.equals("")){
		vt = cons_db.getManSearch3("", s_kd, t_wd);
	}	
	int vt_size = vt.size();
	
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
	
	function send_apk(nm, m_tel){
		var fm = document.form1;
				
		if (confirm("������ȣ �ν� URL ���ڸ� �߼��Ͻðڽ��ϱ�?") ){	
			fm.action="send_apk_a.jsp?nm="+nm+ "&m_tel="+m_tel;		
			fm.target='i_no';
			fm.submit();
		}
	}	
	
	<%if(go_url.equals("/fms2/pay_mng/pay_dir_reg.jsp")){%>
	function Disp2(title, nm, tel, m_tel){
		var fm = document.form1;
		opener.form1.call_t_nm.value 	= nm;
		opener.form1.call_t_tel.value 	= m_tel;	
		if(m_tel == '' && tel !=''){
			opener.form1.call_t_tel.value 	= tel;	
		} 
		self.close();
	}			
	<%}else{%>	
	function Disp1(user_pos, user_id, user_nm, user_h_tel, user_m_tel){
		var fm = document.form1;
		if('<%=go_url%>' == '/fms2/consignment_new/cons_reg_step3.jsp' && '<%=size%>' == '1'){
			if(fm.value.value == '1'){
				opener.form1.<%=st%>_tel.value 		= user_h_tel;
				opener.form1.<%=st%>_title.value 	= user_pos;
				opener.form1.<%=st%>_man.value 		= user_nm;
				opener.form1.<%=st%>_m_tel.value 	= user_m_tel;		
			}else{
				opener.form1.<%=st%>_id.value 		= user_id;
				opener.form1.<%=st%>_nm.value 		= user_nm;
				opener.form1.<%=st%>_m_tel.value 	= user_m_tel;					
			}
		}else if('<%=go_url%>' == '/fms2/consignment_new/cons_reg_step2.jsp' && '<%=size%>' == '1'){
			if(fm.value.value == '1'){
				opener.form1.<%=st%>_tel.value 		= user_h_tel;
				opener.form1.<%=st%>_title.value 	= user_pos;
				opener.form1.<%=st%>_man.value 		= user_nm;
				opener.form1.<%=st%>_m_tel.value 	= user_m_tel;		
			}else{
				opener.form1.<%=st%>_id.value 		= user_id;
				opener.form1.<%=st%>_nm.value 		= user_nm;
				opener.form1.<%=st%>_m_tel.value 	= user_m_tel;					
			}
		}else{
			if(fm.value.value == '1'){
				opener.form1.<%=st%>_tel[<%=idx%>].value 	= user_h_tel;
				opener.form1.<%=st%>_title[<%=idx%>].value 	= user_pos;
				opener.form1.<%=st%>_man[<%=idx%>].value 	= user_nm;
				opener.form1.<%=st%>_m_tel[<%=idx%>].value 	= user_m_tel;		
			}else{
				opener.form1.<%=st%>_id[<%=idx%>].value 	= user_id;
				opener.form1.<%=st%>_nm[<%=idx%>].value 	= user_nm;
				opener.form1.<%=st%>_m_tel[<%=idx%>].value 	= user_m_tel;					
			}
		}
		self.close();
	}

	function Disp2(title, nm, tel, m_tel){
		var fm = document.form1;
		opener.form1.<%=st%>_tel[<%=idx%>].value 	= tel;
		opener.form1.<%=st%>_title[<%=idx%>].value 	= title;
		opener.form1.<%=st%>_man[<%=idx%>].value 	= nm;
		opener.form1.<%=st%>_m_tel[<%=idx%>].value 	= m_tel;		
		self.close();
	}		
	
	function Disp3(nm, m_tel){
		var fm = document.form1;
		opener.form1.driver_nm[<%=idx%>].value 		= nm;
		opener.form1.driver_m_tel[<%=idx%>].value 	= m_tel;
		self.close();
	}			
	<%}%>	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='s_man.jsp'>
  <input type='hidden' name='st' value='<%=st%>'>    
  <input type='hidden' name='value' value='<%=value%>'>      
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type='hidden' name='go_url' value='<%=go_url%>'> 
  <input type='hidden' name='size' value='<%=size%>'>   
  <input type='hidden' name='cons_dt' value='<%=cons_dt%>'>     
  <input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>     
  <input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>     
  <input type='hidden' name='car_no' value='<%=car_no%>'>     
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <%if(value.equals("1")){//�Ƹ���ī%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�Ƹ���ī</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    	
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif"  border="0" align=absmiddle>&nbsp;		
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>��ȣ</option>
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>����</option>		  
            </select>&nbsp;
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
		    <!--<input type="button" name="b_ms2" value="�˻�" onClick="javascript:search();" class="btn">-->
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
                    <td class=title width="10%">����</td>			
                    <td class=title width="15%">����</td>
                    <td class=title width="15%">�μ�</td>			
                    <td class=title width="15%">����</td>						
                    <td class=title width="15%">����</td>
                    <td class=title width="15%">����ó</td>			
                    <td class=title width="15%">�ڵ���</td>			
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                    <td><%=i+1%></td>
                    <td><%=ht.get("BR_NM")%></td>
                    <td><%=ht.get("NM")%></td>
                    <td><%=ht.get("USER_POS")%></td>		  		  
                    <td><a href="javascript:Disp1('<%=ht.get("USER_POS")%>', '<%=ht.get("USER_ID")%>', '<%=ht.get("USER_NM")%>', '<%=ht.get("USER_H_TEL")%>', '<%=ht.get("USER_M_TEL")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM")%></a></td>
                    <td><%=ht.get("USER_H_TEL")%></td>		  		  
                    <td><%=ht.get("USER_M_TEL")%></td>		  		  		  
                </tr>
            <%		}%>
            </table>
	    </td>
    </tr>	
	<%}%>
    <%if(value.equals("4")){%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�Ƹ���ī</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>	
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif" border="0" align=absmiddle>&nbsp;
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>��ȣ</option>
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>����</option>		  
            </select>&nbsp;
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
		    <a href="javascript:search();" class="btn"><img src="/acar/images/center/button_search.gif"  border="0" align=absmiddle></a>
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>		
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="10%">����</td>			
                    <td class=title width="15%">����</td>
                    <td class=title width="15%">�μ�</td>			
                    <td class=title width="15%">����</td>						
                    <td class=title width="15%">����</td>
                    <td class=title width="15%">�ڵ���</td>			
                    <td class=title width="15%">��������</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                    <td><%=i+1%></td>
                    <td><%=ht.get("BR_NM")%></td>
                    <td><%=ht.get("NM")%></td>
                    <td><%=ht.get("USER_POS")%></td>		  		  
                    <td><a href="javascript:Disp1('<%=ht.get("USER_POS")%>', '<%=ht.get("USER_ID")%>', '<%=ht.get("USER_NM")%>', '<%=ht.get("USER_H_TEL")%>', '<%=ht.get("USER_M_TEL")%>')" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM")%></a></td>
                    <td><%=ht.get("USER_M_TEL")%></td>		  		  		  
                    <td><%=ht.get("STANDBY_ST")%></td>		  		  		  
                </tr>
            <%		}%>
            </table>
	    </td>
    </tr>	
	<%}%>	
	<%if(value.equals("2")){//��
		//���ΰ�����������
		Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "");
		int mgr_size = car_mgrs.size();	
	%>	
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> ����ȣ : <%=rent_l_cd%> <%=car_no%> ��������</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>		
    <tr> 
        <td class=line>
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width="10%">����</td>
                    <td class=title width="15%">����</td>
                    <td class=title width="20%">�μ�/����</td>
                    <td class=title width="15%">����</td>		  
                    <td class=title width="20%">����ó</td>
                    <td class=title width="20%">�ڵ���</td>
                </tr>
                <%for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);%>
                <tr align="center">
                    <td><%=i+1%></td>
                    <td><%=mgr.getMgr_st()%></td>
                    <td><%=mgr.getMgr_dept()%> <%=mgr.getMgr_title()%></td>		  
                    <td><a href="javascript:Disp2('<%=mgr.getMgr_title()%>', '<%=mgr.getMgr_nm()%>', '<%=mgr.getMgr_tel()%>', '<%=mgr.getMgr_m_tel()%>')" onMouseOver="window.status=''; return true"><%=mgr.getMgr_nm()%></a></td>
                    <td><%=mgr.getMgr_tel()%></td>
                    <td><%=mgr.getMgr_m_tel()%></td>
                </tr>
                <%}%>
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>    		
    <tr> 
        <td> <img src="/acar/images/center/arrow_gsjg.gif"  border="0" align=absmiddle>&nbsp;		
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>��ȣ</option>
	      <option value='3' <%if(s_kd.equals("3"))%>selected<%%>>����ȣ</option>
	      <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>������ȣ</option>
            </select>&nbsp;
            <input type="text" name="t_wd" value="<%=t_wd%>" size="20" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
		    &nbsp;<input type="button" name="b_ms2" value="�˻�" onClick="javascript:search();" class="btn">		    
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>		
    <tr> 
        <td class=line>
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width="10%">����</td>
                    <td class=title width="15%">����</td>
                    <td class=title width="20%">�μ�/����</td>
                    <td class=title width="15%">����</td>		  
                    <td class=title width="20%">����ó</td>
                    <td class=title width="20%">�ڵ���</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
        				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                    <td><%=i+1%></td>
                    <td><%=ht.get("GUBUN")%><%if(!String.valueOf(ht.get("CAR_NO")).equals("")){%><BR><%=ht.get("CAR_NO")%><%}%></td>
                    <td><%=ht.get("TITLE")%></td>		  
                    <td><a href="javascript:Disp2('<%=ht.get("TITLE")%>', '<%=ht.get("NM")%>', '<%=ht.get("TEL")%>', '<%=ht.get("M_TEL")%>')" onMouseOver="window.status=''; return true"><%=ht.get("NM")%></a></td>
                    <td><%=ht.get("TEL")%></td>
                    <td><%=ht.get("M_TEL")%></td>
                </tr>
                <%		}%>
            </table>
	    </td>
    </tr>	
	<%}%>
	<%if(value.equals("3")){//���¾�ü%>	
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif"  border="0" align=absmiddle>&nbsp;		 
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>��ȣ</option>
            </select>&nbsp;
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=whitetext onKeyDown="javasript:enter()" style='IME-MODE: active'>
		    <!--<input type="button" name="b_ms2" value="�˻�" onClick="javascript:search();" class="btn">-->
        </td>
    </tr>
    
   	<%if( !t_wd.equals("")){%>
    <tr> 
        <td>�� �ֱ� 1�� ���� Ź�۹����� ������ ����Ʈ�Դϴ�.</td>
    </tr>
    <tr> 
        <td>�� ������ȣ�ν��� �������� �������� ������, ��а� �Ƹ���Ź�۸� ����մϴ�.</td>
    </tr>
	<%}%>
	     
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    
    	
    <tr> 
        <td class=line>
    	    <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width="10%">����</td>
                    <td class=title width="40%">�����ڸ�</td>
                    <td class=title width="50%">�ڵ�����ȣ</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
    				String m_tel = (String)ht.get("M_TEL");
    				String name = (String)ht.get("NM");
    				
    				if(!m_tel.contains("01035580026")  &&  !m_tel.contains("01090905323") &&  !m_tel.contains("01040140911")  && !m_tel.contains("01043747353") && !name.contains("�̿���")){		//�Ϳ�ö(�޴�����ȣ �ٲ�)(2017.09.25) , ������, ������, ������ �߰�     		   					
    																																													// 2020.11.17.������ ���� ��Ͽ� ����. !m_tel.contains("01049451922") ���ǿ��� ����. 
    			%>
	                <tr align="center">
	                    <td><%=i+1%></td>
	                    <td><a href="javascript:Disp3('<%=ht.get("NM")%>', '<%=ht.get("M_TEL")%>')" onMouseOver="window.status=''; return true"><%=ht.get("NM")%></a></td>
	                    <td><%=ht.get("M_TEL")%>
	                      &nbsp;&nbsp;
	                    <a href="javascript:send_apk('<%=ht.get("NM")%>', '<%=ht.get("M_TEL")%>')" onMouseOver="window.status=''; return true">������ȣ�ν�</a> <!-- �ȵ���̵忡 ���ؼ� -->
	                    	     
	                    </td>
	                </tr>
                <%		
                	}
                }%>
            </table>
	    </td>
    </tr>	
	<%}%>	

    <tr> 
        <td align="center">
	        <a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>		
	    </td>
    </tr>
</table>
</form>
</body>
</html>