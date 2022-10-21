<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.consignment.*"%>
<jsp:useBean id="cons_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/agent/cookies.jsp" %> 

<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	String value 		= request.getParameter("value")==null?"":request.getParameter("value");
	String idx 			= request.getParameter("idx")==null?"":request.getParameter("idx");
	String req_id 		= request.getParameter("req_id")==null?ck_acar_id:request.getParameter("req_id");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean user_bean = umd.getUsersBean(req_id);
	
	//������� �߰�(����� �� ����ó ��������)
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	UsersBean udt_mng_bean_s 	= umd.getUsersBean(nm_db.getWorkAuthUser("�������������"));
	UsersBean udt_mng_bean_b2 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ����������"));
	UsersBean udt_mng_bean_b 	= umd.getUsersBean(nm_db.getWorkAuthUser("�λ�������"));
	UsersBean udt_mng_bean_d 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));			
	UsersBean udt_mng_bean_g 	= umd.getUsersBean(nm_db.getWorkAuthUser("�뱸������"));
	UsersBean udt_mng_bean_j 	= umd.getUsersBean(nm_db.getWorkAuthUser("����������"));
	
	Vector vt = new Vector();
	if(value.equals("1")){//���
		String[] capital_list = new String[] {"S1", "S2", "I1", "K3",  "S3", "S4", "S5", "S6"};
		boolean isCapital = Arrays.asList(capital_list).contains(br_id);
		
		vt = cons_db.getPlaceSearch1("", s_kd, t_wd, isCapital);
	}
	if(value.equals("2") && !t_wd.equals("")){//��
		vt = cons_db.getPlaceSearch2Agent("", s_kd, t_wd, ck_acar_id);
	}
	if(value.equals("3") && !t_wd.equals("")){//���¾�ü
		vt = cons_db.getPlaceSearch3("", s_kd, t_wd);
	}
	int vt_size = vt.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
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
	
	function Disp1(gubun, nm, addr, mng_off, tel){
		var fm = document.form1;
		opener.form1.<%=st%>_place[<%=idx%>].value 	= nm;
		opener.form1.<%=st%>_comp[<%=idx%>].value 	= '(��)�Ƹ���ī '+mng_off;
		opener.form1.<%=st%>_tel[<%=idx%>].value 	= tel;
		<%//if(st.equals("from")){%>
		opener.form1.<%=st%>_title[<%=idx%>].value 	= '<%=user_bean.getUser_pos()%>';
		opener.form1.<%=st%>_man[<%=idx%>].value 	= '<%=user_bean.getUser_nm()%>';
		opener.form1.<%=st%>_m_tel[<%=idx%>].value 	= '<%=user_bean.getUser_m_tel()%>';		
		<%//}%>
		self.close();
	}

	//��༱��
	function Disp2(client_id, firm_nm, client_nm, gubun, tel, m_tel, addr, title){
		var fm = document.form1;
		
		<%if(go_url.equals("/agent/car_pur/pur_doc_i.jsp")){%>
			opener.form1.rent_ext.value					= addr.substr(0,11);
		<%}else{%>
			opener.form1.<%=st%>_place[<%=idx%>].value 	= addr;
			opener.form1.<%=st%>_comp[<%=idx%>].value 	= firm_nm;
			opener.form1.<%=st%>_tel[<%=idx%>].value 	= tel;
			opener.form1.client_id[<%=idx%>].value 		= client_id;	
			opener.form1.<%=st%>_title[<%=idx%>].value 	= title;
			opener.form1.<%=st%>_man[<%=idx%>].value 	= client_nm;
			opener.form1.<%=st%>_m_tel[<%=idx%>].value 	= m_tel;		
		<%}%>
			
		self.close();
	}		

	function Disp3(off_nm, own_nm, off_tel, off_addr){
		var fm = document.form1;
		opener.form1.<%=st%>_place[<%=idx%>].value 	= off_addr;
		opener.form1.<%=st%>_comp[<%=idx%>].value 	= off_nm;
		opener.form1.<%=st%>_tel[<%=idx%>].value 	= off_tel;
		opener.form1.<%=st%>_man[<%=idx%>].value 	= own_nm;		
		self.close();
	}
	
	// ������� �߰� 
	function Disp4(dp4_n){
		var from_place = $("#d_n"+dp4_n).text();
		var from_comp = $("#d_a"+dp4_n).text();
		var from_title = $("#d_u"+dp4_n).val();
		var from_tel = $("#d_p"+dp4_n).val();
		var fm = document.form1;
		opener.form1.<%=st%>_place[<%=idx%>].value 	= from_place;
		opener.form1.<%=st%>_comp[<%=idx%>].value 	= from_comp;
		opener.form1.<%=st%>_title[<%=idx%>].value 	= from_title;	
		opener.form1.<%=st%>_tel[<%=idx%>].value 	= from_tel;
		opener.form1.<%=st%>_man[<%=idx%>].value 	= "";	
		opener.form1.<%=st%>_m_tel[<%=idx%>].value 	= "";
		self.close();
	}
	
//-->
</script>
</head>

<body <%if(!value.equals("1")){%>onload="document.form1.t_wd.focus()"<%}%>>
<form name='form1' method='post' action='s_place.jsp'>
  <input type='hidden' name='st' value='<%=st%>'>    
  <input type='hidden' name='value' value='<%=value%>'>      
  <input type="hidden" name="idx" value="<%=idx%>">
 <input type='hidden' name='go_url' value='<%=go_url%>'> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <%if(value.equals("1")){%>
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
        <td class=line2></td>
    </tr>		
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="10%">����</td>
                    <td class=title width="15%">����</td>
                    <td class=title width="30%">�̸�</td>			
                    <td class=title width="45%">�ּ�</td>						
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
        				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                  <td><%=i+1%></td>
                  <td><%=ht.get("GUBUN")%></td>
                  <td><a href="javascript:Disp1('<%=ht.get("GUBUN")%>', '<%=ht.get("NM")%>', '<%=ht.get("ADDR")%>', '<%=ht.get("MNG_OFF")%>', '<%=ht.get("TEL")%>')" onMouseOver="window.status=''; return true"><%=ht.get("NM")%></a></td>
                  <td><span title='<%=ht.get("ADDR")%>'><%=Util.subData(String.valueOf(ht.get("ADDR")), 18)%></span></td>
                </tr>
                <%		}%>
            </table>
	    </td>
    </tr>	
	<%}%>
	<%if(value.equals("3")){%>
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>���¾�ü</span></span></td>
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
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>����ڹ�ȣ</option>
            </select>
            <input type="text" name="t_wd" value="<%=t_wd%>" size="20" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
    		
    		  <a href="javascript:search();"><img src="/acar/images/center/button_search.gif"  border="0" align=absmiddle></a>	
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
                  <td class=title width="5%">����</td>
                  <td class=title width="12%">����ڹ�ȣ</td>
                  <td class=title width="33%">��ȣ</td>
                  <td class=title width="10%">��ǥ��</td>
                  <td class=title width="15%">����ó</td>
                  <td class=title width="25%">�ּ�</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
        				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                  <td><%=i+1%></td>
                  <td><%=ht.get("ENT_NO")%></td>		  
                  <td><a href="javascript:Disp3('<%=ht.get("OFF_NM")%>', '<%=ht.get("OWN_NM")%>', '<%=ht.get("OFF_TEL")%>', '<%=ht.get("OFF_ADDR")%>')" onMouseOver="window.status=''; return true"><%=ht.get("OFF_NM")%></a></td>
                  <td><%=ht.get("OWN_NM")%></td>
                  <td><%=ht.get("OFF_TEL")%></td>
                  <td><span title='<%=ht.get("OFF_ADDR")%>'><%=Util.subData(String.valueOf(ht.get("OFF_ADDR")), 12)%></span></td>
                </tr>
                <%		}%>
            </table>
	    </td>
    </tr>	
	<%}%>
	<%if(value.equals("2")){%>	
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif"  border="0" align=absmiddle>&nbsp;
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>��ȣ</option>
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>������ȣ</option>		  
            </select>
            <input type="text" name="t_wd" value="<%=t_wd%>" size="20" class=text onKeyDown="javasript:enter()" style='IME-MODE: active' >
    		<a href="javascript:window.search();"><img src="/acar/images/center/button_search.gif"  border="0" align=absmiddle></a>		
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
                  <td class=title width="5%">����</td>
                  <td class=title width="20%">��ȣ</td>
                  <td class=title width="13%">����</td>
                  <td class=title width="17%">����ó</td>
                  <td class=title width="45%">�ּ�</td>
                </tr>
                <%for (int i = 0 ; i < vt_size ; i++){
        				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr align="center">
                  <td><%=i+1%></td>
                  <td>
                  	<% 
                  		// �� ����� ���� ���� 2021.01.20.
                  		String nm = "";
                  		String tel = "";
                  		String m_tel = "";
                  		String title = "";
                  		
                  		String mgr_nm1 = String.valueOf(ht.get("MGR_NM1"));
                  		String mgr_nm2 = String.valueOf(ht.get("MGR_NM2"));
                  		
                  		if(!mgr_nm1.equals("")){		// �����̿��� ���� ���� ��� �����̿��ڰ� �����.
                  			nm = mgr_nm1;
                  			tel = String.valueOf(ht.get("MGR_TEL1"));
                  			m_tel = String.valueOf(ht.get("MGR_M_TEL1"));
                  			title = String.valueOf(ht.get("MGR_TITLE1"));
                  		} else if(!mgr_nm2.equals("")){	// ���������� ���� ���� ��� ���������ڰ� �����.
                  			nm = mgr_nm2;
                  			tel = String.valueOf(ht.get("MGR_TEL2"));
                  			m_tel = String.valueOf(ht.get("MGR_M_TEL2"));
                  			title = String.valueOf(ht.get("MGR_TITLE2"));
                  		} // �����̿���, ���������� ���� ��� ���� ��� ����� �������� ����.
                  	%>
                  	<%-- <a href="javascript:Disp2('<%=ht.get("CLIENT_ID")%>', '<%=ht.get("FIRM_NM")%>', '<%=ht.get("CLIENT_NM")%>', '<%=ht.get("GUBUN")%>', '<%=ht.get("TEL")%>', '<%=ht.get("M_TEL")%>', '<%=ht.get("ADDR")%>', '<%=ht.get("TITLE")%>')" onMouseOver="window.status=''; return true"><%=ht.get("FIRM_NM")%></a> --%>
                  	<a href="javascript:Disp2('<%=ht.get("CLIENT_ID")%>', '<%=ht.get("FIRM_NM")%>', '<%=nm%>', '<%=ht.get("GUBUN")%>', '<%=tel%>', '<%=m_tel%>', '<%=ht.get("ADDR")%>', '<%=title%>')" onMouseOver="window.status=''; return true"><%=ht.get("FIRM_NM")%></a>
                  </td>
                  <td><%=ht.get("GUBUN")%></td>
                  <td><%=ht.get("TEL")%></td>
                  <td><%=ht.get("ADDR")%></td>
                </tr>
                <%		}%>
            </table>
	    </td>
    </tr>	
	<%}%>
	
	<!-- ������� �߰� -->
	<%if(value.equals("4")){%>
    <tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
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
                    <td class=title width="15%">�μ���</td>
                    <td class=title width="30%">����/��ȣ</td>			
                    <td class=title width="45%">�ּ�</td>						
                </tr>
                <tr align="center">
                  <td>1</td>
                  <td>���ﺻ��</td>
                  <td id="d_n1"><a href="javascript:Disp4(1);" onMouseOver="window.status=''; return true">������ ����������</a></td>
                  <td id="d_a1"><span>����� �������� �������� 34�� 9</span></td>
                  <td>
                  	<input type="hidden" id="d_u1" value="<%=udt_mng_bean_s.getDept_nm()%> <%=udt_mng_bean_s.getUser_nm()%> <%=udt_mng_bean_s.getUser_pos()%>">
                  	<input type="hidden" id="d_p1" value="<%=udt_mng_bean_s.getHot_tel()%>">
                  </td>
                </tr>
                <%-- <tr align="center">
                  <td>2</td>
                  <td>�λ�����</td>                  
                  <td id="d_n2"><a href="javascript:Disp4(2);" onMouseOver="window.status=''; return true">������������� ������</a></td>
                  <td id="d_a2"><span>�λ걤���� ������ ����4�� 585-1</span></td>
                  <td>
                  	<input type="hidden" id="d_u2" value="<%=udt_mng_bean_b2.getDept_nm()%> <%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>">
                  	<input type="hidden" id="d_p2" value="<%=udt_mng_bean_b2.getHot_tel()%>">
                  </td>
                </tr> --%>
                <tr align="center">
                  <td>2</td>
                  <td>�λ�����</td>                  
                  <td id="d_n3"><a href="javascript:Disp4(3);" onMouseOver="window.status=''; return true">�����̵���ǽ��� ����1�� ������</a></td>
                  <td id="d_a3"><span>�λ걤���� ������ ����õ�� 230���� 70 ����1�� (���굿,�����̵���ǽ���)�����̵�������</span></td>
                  <td>
                  	<input type="hidden" id="d_u3" value="<%=udt_mng_bean_b2.getDept_nm()%> <%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>">
                  	<input type="hidden" id="d_p3" value="<%=udt_mng_bean_b2.getHot_tel()%>">
                  </td>
                </tr>
                <tr align="center">
                  <td>3</td>
                  <td>�λ�����</td>                  
                  <td id="d_n4"><a href="javascript:Disp4(4);" onMouseOver="window.status=''; return true">����ī(������)</a></td>
                  <td id="d_a4"><span>�λ걤���� ������ ����4�� 700-5</span></td>
                  <td>
                  	<input type="hidden" id="d_u4" value="<%=udt_mng_bean_b.getDept_nm()%> <%=udt_mng_bean_b.getUser_nm()%> <%=udt_mng_bean_b.getUser_pos()%>">
                  	<input type="hidden" id="d_p4" value="<%=udt_mng_bean_b.getHot_tel()%>">
                  </td>
                </tr>
                <tr align="center">
                  <td>4</td>
                  <td>��������</td>                  
                  <td id="d_n5"><a href="javascript:Disp4(5);" onMouseOver="window.status=''; return true">�̼���ũ</a></td>
                  <td id="d_a5"><span>���������� ������ ��õ�Ϸ�59���� 10(���� 690-3)</span></td>
                  <td>
                  	<input type="hidden" id="d_u5" value="<%=udt_mng_bean_d.getDept_nm()%> <%=udt_mng_bean_d.getUser_nm()%> <%=udt_mng_bean_d.getUser_pos()%>">
                  	<input type="hidden" id="d_p5" value="<%=udt_mng_bean_d.getHot_tel()%>">
                  </td>
                </tr>
                <tr align="center">
                  <td>5</td>
                  <td>�뱸����</td>                  
                  <td id="d_n6"><a href="javascript:Disp4(6);" onMouseOver="window.status=''; return true">�뱸 ������</a></td>
                  <td id="d_a6"><span>�뱸������ �޼��� �Ŵ絿 321-86</span></td>
                  <td>
                  	<input type="hidden" id="d_u6" value="<%=udt_mng_bean_g.getDept_nm()%> <%=udt_mng_bean_g.getUser_nm()%> <%=udt_mng_bean_g.getUser_pos()%>">
                  	<input type="hidden" id="d_p6" value="<%=udt_mng_bean_g.getHot_tel()%>">
                  </td>
                </tr>
                <tr align="center">
                  <td>6</td>
                  <td>��������</td>                  
                  <td id="d_n7"><a href="javascript:Disp4(7);" onMouseOver="window.status=''; return true">������ڵ�����ǰ��</a></td>
                  <td id="d_a7"><span>���ֱ����� ���걸 �󹫴�� 233 (������ 1360)</span></td>
                  <td>
                  	<input type="hidden" id="d_u7" value="<%=udt_mng_bean_j.getDept_nm()%> <%=udt_mng_bean_j.getUser_nm()%> <%=udt_mng_bean_j.getUser_pos()%>">
                  	<input type="hidden" id="d_p7" value="<%=udt_mng_bean_j.getHot_tel()%>">
                  </td>
                </tr>
                <tr align="center">
                  <td>7</td>
                  <td>�λ�����</td>                  
                  <td id="d_n8"><a href="javascript:Disp4(8);" onMouseOver="window.status=''; return true">������TS</a></td>
                  <td id="d_a8"><span>�λ�� ������ �ȿ���7������ 10(���굿 363-13����)</span></td>
                  <td>
                  	<input type="hidden" id="d_u8" value="<%=udt_mng_bean_b2.getDept_nm()%> <%=udt_mng_bean_b2.getUser_nm()%> <%=udt_mng_bean_b2.getUser_pos()%>">
                  	<input type="hidden" id="d_p8" value="<%=udt_mng_bean_b2.getHot_tel()%>">
                  </td>
                </tr>
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