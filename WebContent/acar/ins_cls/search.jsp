<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//����� ������ȣ
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//����� �Ҽӿ�����
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//��ȸ
	InsDatabase ins_db = InsDatabase.getInstance();
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
	
	//��༱��
	function Disp(c_id, ins_st){
		var fm = document.form1;
		fm.c_id.value = c_id;
		fm.ins_st.value = ins_st;		
		fm.action = "ins_cls_sc.jsp";		
		if('<%=go_url%>' == '/fms2/insure/ins_doc_reg_c.jsp'){
			fm.action = "/fms2/insure/ins_doc_reg_c.jsp";
		}
		fm.target = "c_foot";
		fm.submit();	
		self.close();
	}		
	//���������
	function DispMng(c_id, ins_st){
		var fm = document.form1;
		fm.c_id.value = c_id;
		fm.ins_st.value = ins_st;		
		fm.action = "../ins_mng/ins_u_frame.jsp";		
		fm.target = "d_content";
		if('<%=go_url%>' == '/fms2/insure/ins_doc_reg_c.jsp'){
			fm.action = "/fms2/insure/ins_doc_reg_c.jsp";
			fm.target = "c_foot";
		}
		fm.submit();	
		self.close();
	}	
	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='search.jsp'>
<input type='hidden' name="auth_rw" value='<%=auth_rw%>'>
<input type='hidden' name="user_id" value='<%=user_id%>'>
<input type='hidden' name="br_id" value='<%=br_id%>'>
<input type='hidden' name="go_url" value='<%=go_url%>'>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='ins_st' value=''>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>������� > <span class=style5>������ȸ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  	
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="/acar/images/center/arrow_gsjg.gif" align=absmiddle>&nbsp;
        <select name='s_kd'>
          <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>��ȣ</option>
          <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>������ȣ</option>
          <option value='3' <%if(s_kd.equals("3"))%>selected<%%>>�����ȣ</option>
          <option value='4' <%if(s_kd.equals("4"))%>selected<%%>>���ǹ�ȣ</option>
        </select>
        <input type="text" name="t_wd" value="<%=t_wd%>" size="20" class=text onKeyDown="javasript:enter()">
        <a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a> 
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
                    <td class=title width="5%" rowspan="2">����</td>
                    <td class=title colspan="2">������ȣ</td>
                    <td class=title width="10%" rowspan="2">������</td>
                    <td class=title width="15%" rowspan="2">���ǹ�ȣ</td>			
                    <td class=title width="8%" rowspan="2">��������</td>
                    <td class=title width="8%" rowspan="2">�㺸����</td>
                    <td class=title width="18%" rowspan="2">����Ⱓ</td>
                    <td class=title width="10%" rowspan="2">��������</td>					
                    <td class=title width="6%" rowspan="2">����</td>
                </tr>
                <tr> 
                    <td class=title width="10%">������</td>
                    <td class=title width="10%">������</td>
                </tr>
              <%//�����̷�-�Ϲݺ���
    			Vector inss = ins_db.getInsList(s_kd, t_wd);
    			int ins_size = inss.size();
    			
    			int count = 0;
    			
    			if(ins_size > 0){
            		for(int i = 0 ; i < ins_size ; i++){
    				Hashtable ins = (Hashtable)inss.elementAt(i);
										
					if(go_url.equals("/fms2/insure/ins_doc_reg_c.jsp") && !String.valueOf(ins.get("INS_STS")).equals("��ȿ"))    continue;
					
					count++;%>
                <tr align="center"> 
                    <td><%=count%></td>
                    <td><%=ins.get("FIRST_CAR_NO")%></td>
                    <td><%=ins.get("CAR_NO")%></td>
                    <td><%=ins.get("INS_COM_NM")%></td>
                    <td><%=ins.get("INS_CON_NO")%></td>			
                    <td><%=ins.get("INS_KD")%></td>
                    <td><%=ins.get("CAR_USE")%></td>
                    <td>
        			<%if(String.valueOf(ins.get("INS_STS")).equals("��ȿ") || String.valueOf(ins.get("INS_STS")).equals("����")){%>
        			<a href="javascript:Disp('<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')"><%=AddUtil.ChangeDate2((String)ins.get("INS_START_DT"))%>~<%=AddUtil.ChangeDate2((String)ins.get("INS_EXP_DT"))%></a>
        			<%}else{%>
        			<a href="javascript:DispMng('<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')"><%=AddUtil.ChangeDate2((String)ins.get("INS_START_DT"))%>~<%=AddUtil.ChangeDate2((String)ins.get("INS_EXP_DT"))%></a>
        			<%}%>
        			</td>
                    <td><%=AddUtil.ChangeDate2((String)ins.get("EXP_DT"))%></td>					
                    <td><%=ins.get("INS_STS")%></td>
                </tr>
              <%		}
    		  }%>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right"><a href='javascript:window.close()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a></td>
    </tr>
</table>
</form>
</body>
</html>