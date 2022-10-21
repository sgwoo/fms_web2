<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_pre.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
				

	CommonDataBase c_db = CommonDataBase.getInstance();
	CusPre_Database cp_db = CusPre_Database.getInstance();	
	

	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	Hashtable id = c_db.getDamdang_id(user_nm);
	user_id = String.valueOf(id.get("USER_ID"));	
	

	//20150708 �Ϲݽ� ���� ������ ����Ʈ (�뿩������ ��������Ÿ� 5000km ��������)
	Vector vt = cp_db.getLcRentWayGeneralNotServList(user_id);
	int vt_size = vt.size();

%>

<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//�ڵ��� �������
	function go_cus_reg_serv(car_no){
		var fm = document.form1;
		fm.action = "../cus_reg/cus_reg_frame.jsp?s_gubun1=2&s_kd=2&t_wd="+car_no;
		fm.target = "d_content";
		fm.submit();
	}

	//�� ����
	function view_client(m_id, l_cd, r_st){
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=720, height=550, scrollbars=yes");
	}
	
	//������������ ����
	function next_serv_cng(car_mng_id, serv_id){
		var theForm = document.form1;
		var auth_rw = theForm.auth_rw.value;	
		var url = "?auth_rw=" + auth_rw
			+ "&car_mng_id=" + car_mng_id
			+ "&serv_id=" + serv_id;

		var SUBWIN="/acar/cus_sch/next_serv_cng.jsp" + url;	
	
		window.open(SUBWIN, 'popwin_next_serv_cng','scrollbars=yes,status=no,resizable=no,width=440,height=150,top=200,left=500');
	}

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
-->
</script>
</head>

<body><a name="top"></a>
<form name='form1' method='post' action=''>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><a name='1'></a></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Ϲݽ� �� ���� �ȳ� ������ (�뿩������ ��������Ÿ� 5000km ���޽� �ȳ�) : �� <font color="#FF0000"><%= vt.size() %></font>��</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=3% class='title'>����</td>
                    <td width=27% class='title'>��ȣ</td>
                    <td width=10% class='title'>������ȣ</td>
                    <td width=20% class='title'>����</td>
                    <td width=15% class='title'>���ʴ뿩������</td>
                    <td width=15% class='title'>�뿩������</td>
                    <td width=10% class='title'>������</td>
                </tr>
                <%	if(vt.size() > 0){
        			for (int i = 0 ; i < vt.size() ; i++){
        				Hashtable ht = (Hashtable)vt.elementAt(i);
        	%>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><a href="javascript:view_client('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','1')" onMouseOver="window.status=''; return true"><%= ht.get("FIRM_NM") %></a></td>
                    <td align="center"><%=ht.get("CAR_NO")%></td>
                    <td align="center"><%=ht.get("CAR_NM")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("F_RENT_START_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
                    <td align="center"><a href="javascript:go_cus_reg_serv('<%= ht.get("CAR_NO") %>')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>          
                </tr>
                <% 		}
        		}else{
        	%>
                <tr>
                    <td colspan="7" align="center">�ڷᰡ �����ϴ�.</td>
                </tr>
                <%	}%>
            </table>
        </td>
    </tr>		
    <tr> 
        <td><a name='2'></a></td>
    </tr>
    <%
	//������ �����Ϸκ��� ����Ÿ� 7,000km �ʰ�(����) ����Ʈ -> 20150515 10,000km ����
	vt = cp_db.getOver_10000km(user_id);    
    %>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2> ������ �����Ϸ� ���� ����Ÿ�<font color="#FF0000"> 10000km</font> �ʰ�(����) ����Ʈ : �� <font color="#FF0000"><%= vt.size() %></font> ��</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td width="100%"  class='line' > 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title width=3%>����</td>
                    <td class=title width=19%>��ȣ</td>
                    <td class=title width=10%>������ȣ</td>
                    <td class=title width=10%>�ֱ���������</td>
                    <td class=title width=10%>����������</td>
                    <td class=title width=10%>�������񳻿�</td>
                    <td class=title width=7%>�ֱ�km</td>
                    <td class=title width=7%>����km</td>
                    <td class=title width=7%>�ʰ�km</td>                    
                    <td class=title width=9%>������</td>
                </tr>
        	<%	if(vt.size() > 0){
        			for(int i = 0 ; i < vt.size() ; i++){
        				Hashtable ht = (Hashtable)vt.elementAt(i); 
      		%>		  
                <tr> 
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><a href="javascript:view_client('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("FEE_RENT_ST")%>')" onMouseOver="window.status=''; return true"><%= ht.get("FIRM_NM") %></a></td>
                    <td align="center"><%= ht.get("CAR_NO") %></td>
                    <td align="center"><%= AddUtil.ChangeDate2((String)ht.get("SERV_DT")) %></td>
                    <td align="center"><%= AddUtil.ChangeDate2((String)ht.get("NEXT_SERV_DT")) %></td>
                    <td align="center"><%= ht.get("NEXT_REP_CONT") %></td>
                    <td align="right"><%=Util.parseDecimal(ht.get("TOT_DIST")) %>km</td>
                    <td align="right"><%=Util.parseDecimal(ht.get("TODAY_DIST")) %>km</td>
                    <td align="right"><%if(AddUtil.parseLong(String.valueOf(ht.get("TODAY_DIST")))-AddUtil.parseLong(String.valueOf(ht.get("TOT_DIST"))) >= 10000 ) {%><font color='red'><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("TODAY_DIST")))-AddUtil.parseLong(String.valueOf(ht.get("TOT_DIST"))))%><%}else{%><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("TODAY_DIST")))-AddUtil.parseLong(String.valueOf(ht.get("TOT_DIST"))))%><%}%>km</td>                    
                    <td align="center"><a href="javascript:go_cus_reg_serv('<%= ht.get("CAR_NO") %>')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                </tr>
          	<% 		}
        		  }else{ 
        	%>
                <tr> 
                    <td align="center" colspan="10">10000km �ʰ� ������ �����ϴ�.</td>
                </tr>
        	<% 	} %>
            </table>
        </td>
    </tr>
    <tr> 
        <td><a name='3'></a></td>
    </tr>
    <%
	//������ ��������Ÿ��� ��������Ÿ� ���̰� 1000km �̻��� ���� ����Ʈ	
	vt = cp_db.getLcRentAgreeTodayDistCha1000List(user_id);    
    %>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2> ������ ��������Ÿ��� ��������Ÿ� ���̰� <font color="#FF0000"> 1000km</font> �̻��� ���� ����Ʈ : �� <font color="#FF0000"><%= vt.size() %></font> ��</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td width="100%"  class='line' > 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title width=3%>����</td>
                    <td class=title width=20%>��ȣ</td>
                    <td class=title width=10%>������ȣ</td>                    
                    <td class=title width=10%>�뿩������</td>                    
                    <td class=title width=15%>��������Ÿ�</td>
                    <td class=title width=15%>��������������Ÿ�</td>
                    <td class=title width=15%>��������Ÿ�</td>
                    <td class=title width=12%>�ʰ�����Ÿ�</td>                                        
                </tr>
        	<%	if(vt.size() > 0){
        			for(int i = 0 ; i < vt.size() ; i++){
        				Hashtable ht = (Hashtable)vt.elementAt(i); 
      		%>		  
                <tr> 
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><a href="javascript:view_client('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%= ht.get("FIRM_NM") %></a></td>
                    <td align="center"><%= ht.get("CAR_NO") %></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
                    <td align="right"><%=Util.parseDecimal(ht.get("AGREE_DIST")) %>km</td>
                    <td align="right"><%=Util.parseDecimal(ht.get("RENT_EST_DIST")) %>km</td>
                    <td align="right"><%=Util.parseDecimal(ht.get("TODAY_DIST")) %>km</td>
                    <td align="right"><%=Util.parseDecimal(ht.get("CHA_DIST")) %>km</td>
                </tr>
          	<% 		}
        		  }else{ 
        	%>
                <tr> 
                    <td align="center" colspan="8">1000km �ʰ� ������ �����ϴ�.</td>
                </tr>
        	<% 	} %>
            </table>
        </td>
    </tr>    
    </table>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
