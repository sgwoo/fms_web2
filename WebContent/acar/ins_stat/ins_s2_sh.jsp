<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(s_st){
		var fm = document.form1;
		fm.s_st.value = s_st;
		if(fm.gubun2.value == '5' && fm.st_dt.value != '')							fm.st_dt.value 	= ChangeDate3(fm.st_dt.value);
		if(fm.gubun2.value == '5' && fm.end_dt.value != '')							fm.end_dt.value = ChangeDate3(fm.end_dt.value);
		if(fm.gubun2.value == '5' && fm.st_dt.value !='' && fm.end_dt.value=='')	fm.end_dt.value = getTodayBar();
		if(fm.gubun2.value == '3' && fm.s_mon.value != '')							fm.st_dt.value 	= fm.s_mon.value; 
		if(fm.gubun3.value == '5' || fm.gubun3.value == '6')						fm.gubun2.value = "";
		fm.action="ins_s2_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search(3);
	}
	
	//���÷��� Ÿ��(�˻�) - ��ȸ�Ⱓ ���ý�
	function cng_input1(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '3'){ //����
			td_gubun2_1.style.display	= '';
			td_gubun2_2.style.display	= 'none';
		}else if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //�Է�
			td_gubun2_1.style.display	= 'none';
			td_gubun2_2.style.display	= '';
			fm.st_dt.value = '';
			fm.end_dt.value = '';
			fm.st_dt.focus();
		}else{
			td_gubun2_1.style.display	= 'none';
			td_gubun2_2.style.display	= 'none';
		}
	}	
	
	function list_print(){
		fm = document.form1;
		window.open("about:blank",'list_print','scrollbars=yes,status=yes,resizable=yes,width=1000,height=600,left=50,top=50');
		fm.target = "list_print";
		fm.action = "ins_s2_sc_print.jsp";
		fm.submit();
	}	
	function list_excel(){
		fm = document.form1;
		window.open("about:blank",'list_excel','scrollbars=yes,status=yes,resizable=yes,width=1200,height=800,left=50,top=50');
		fm.target = "list_excel";
		fm.action = "ins_s2_sc_excel.jsp";
		if(fm.gubun3.value == '02'){
			fm.action = "ins_s2_sc_excel_2.jsp";
		}
		fm.submit();
	}	
	function list_excel_0038(){
		fm = document.form1;
		window.open("about:blank",'list_excel','scrollbars=yes,status=yes,resizable=yes,width=1200,height=800,left=50,top=50');
		fm.target = "list_excel";
		fm.action = "ins_s2_sc_excel_38.jsp";
		fm.submit();
	}			
//-->
</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"3":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");		
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	Vector branches = c_db.getBranchList(); //������ ����Ʈ ��ȸ
	int brch_size = branches.size();	
	
			//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
		
%>
<form action="./ins_s_sc1.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type='hidden' name='gubun0' value='<%=gubun0%>'>
<!--<input type='hidden' name='gubun3' value='<%=gubun3%>'>-->
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='gubun7' value='<%=gubun7%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> ��� �� ���� > ������� > <span class=style5>���ſ�����Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>   
    <tr> 
        <td width=16%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_su.gif align=absmiddle>&nbsp;
            <select name="gubun1">
              <option value=""   <%if(gubun1.equals("")){%>selected<%}%>>��ü</option>
              <option value="1" <%if(gubun1.equals("1")){%>selected<%}%>>��Ʈ</option>
              <option value="2" <%if(gubun1.equals("2")){%>selected<%}%>>����</option>
            </select>
        </td>
        <td width=16%><img src=/acar/images/center/arrow_yus.gif align=absmiddle>&nbsp;  
            <select name='brch_id'>
              <option value=''>��ü</option>
              <%if(brch_size > 0){
    				for (int i = 0 ; i < brch_size ; i++){
    					Hashtable branch = (Hashtable)branches.elementAt(i);%>
              <option value='<%= branch.get("BR_ID") %>'  <%if(brch_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
              <%= branch.get("BR_NM")%> </option>
              <%	}
    			}%>
            </select>
        </td>
        <td width=16%><img src=/acar/images/center/arrow_ggjh.gif align=absmiddle>&nbsp;   
            <select name="gubun2" onChange="javascript:cng_input1()">
              <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>���Ѱ��</option>
              <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>����30����</option>
              <option value="3" <%if(gubun2.equals("3")){%>selected<%}%>>���</option>
			  <option value="4" <%if(gubun2.equals("4")){%>selected<%}%>>�Ϳ�</option>
			  <option value="5" <%if(gubun2.equals("5")){%>selected<%}%>>�˻�</option>
              <option value="6" <%if(gubun2.equals("6")){%>selected<%}%>>������</option>			  			  
              <option value="7" <%if(gubun2.equals("7")){%>selected<%}%>>����</option>
            </select>
        </td>
          <td width=16%> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td id='td_gubun2_1' <%if(gubun2.equals("3")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                      <select name="s_mon">
                        <%for(int i=1; i<13; i++){%>
                        <option value="<%=i%>" <%if(st_dt.equals(Integer.toString(i))){%>selected<%}%>><%=i%>��</option>
                        <%}%>
                      </select>
                    </td>
                    <td id='td_gubun2_2' <%if(gubun2.equals("5")){%>style="display:''"<%}else{%>style='display:none'<%}%>> 
                      <input type="text" name="st_dt" size="10"  value="<%=st_dt%>" class="text" >
                      ~ 
                      <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text" >
                    </td>
                </tr>
            </table>
        </td>
        
        <td width=13%>&nbsp;</td>
        <td width=39%>�������з�&nbsp;
		<select name="gubun3">
              <option value=""  <%if(gubun3.equals("")){ %>selected<%}%>>��ü</option>		
              <option value=""  <%if(gubun3.equals("")){ %>selected<%}%>>==�����з�==</option>		
              <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>�¿�(801~1000)</option>			  
              <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>�¿�(1501~1600)</option>			  
              <option value="3" <%if(gubun3.equals("3")){%>selected<%}%>>�¿�(1901~2000)</option>
              <option value="4" <%if(gubun3.equals("4")){%>selected<%}%>>�¿�(2001~2800)</option>
              <option value="5" <%if(gubun3.equals("5")){%>selected<%}%>>�¿�(2801~)</option>
              <option value="6" <%if(gubun3.equals("6")){%>selected<%}%>>�ٸ���(7��)</option>
              <option value="7" <%if(gubun3.equals("7")){%>selected<%}%>>�ٸ���(8~10��)</option>
              <option value="8" <%if(gubun3.equals("8")){%>selected<%}%>>����(11��)</option>
              <option value="9" <%if(gubun3.equals("9")){%>selected<%}%>>����(12��)</option>			  
              <option value="10" <%if(gubun3.equals("10")){%>selected<%}%>>ȭ��(1�����Ϲ���)</option>			  
              <option value="11" <%if(gubun3.equals("11")){%>selected<%}%>>ȭ��(1������ȭ����)</option>	
              <option value=""  <%if(gubun3.equals("")){ %>selected<%}%>>==�Ƹ���ī�з�==</option>					  		  			  			  
              <option value="100" <%if(gubun3.equals("100")){%>selected<%}%>>��¿�1(800����)</option>			  
              <option value="101" <%if(gubun3.equals("101")){%>selected<%}%>>��¿�2(1000����)</option>	
              <option value="102" <%if(gubun3.equals("102")){%>selected<%}%>>�����¿�(1500����)</option>			  
              <option value="103" <%if(gubun3.equals("103")){%>selected<%}%>>�����¿�(2000����)</option>	
              <option value="104" <%if(gubun3.equals("104")){%>selected<%}%>>�����¿�1(2500����)</option>			  
              <option value="105" <%if(gubun3.equals("105")){%>selected<%}%>>�����¿�2(3000����)</option>	
              <option value="106" <%if(gubun3.equals("106")){%>selected<%}%>>�����¿�3(4000����)</option>			  
              <option value="107" <%if(gubun3.equals("107")){%>selected<%}%>>�����¿�4(4000�ʰ�)</option>	
              <option value="201" <%if(gubun3.equals("201")){%>selected<%}%>>������</option>			  
              <option value="301" <%if(gubun3.equals("301")){%>selected<%}%>>����LPG(2000����)</option>	
              <option value="302" <%if(gubun3.equals("302")){%>selected<%}%>>����LPG(2000�ʰ�)</option>
              <option value="400" <%if(gubun3.equals("400")){%>selected<%}%>>5�ν�¤(1500����)</option>
              <option value="409" <%if(gubun3.equals("409")){%>selected<%}%>>5�ν°���¤(1000����)</option>			  
              <option value="401" <%if(gubun3.equals("401")){%>selected<%}%>>5�ν�¤1(2000����)</option>	
              <option value="402" <%if(gubun3.equals("402")){%>selected<%}%>>5�ν�¤2(2000�ʰ�)</option>              			  
              <option value="501" <%if(gubun3.equals("501")){%>selected<%}%>>7-8�ν�(2000����)</option>	
              <option value="502" <%if(gubun3.equals("502")){%>selected<%}%>>7-8�ν�(2000�ʰ�)</option>			  			  
              <option value="601" <%if(gubun3.equals("601")){%>selected<%}%>>9�ν�(2000����)</option>	
              <option value="602" <%if(gubun3.equals("602")){%>selected<%}%>>9�ν�(2000�ʰ�)</option>			  
              <option value="700" <%if(gubun3.equals("700")){%>selected<%}%>>11�ν�</option>	
              <option value="701" <%if(gubun3.equals("701")){%>selected<%}%>>12�ν�</option>	
              <option value="702" <%if(gubun3.equals("702")){%>selected<%}%>>�����</option>			  			  
              <option value="801" <%if(gubun3.equals("801")){%>selected<%}%>>ȭ��1(1������,ȭ��)</option>	
              <option value="802" <%if(gubun3.equals("802")){%>selected<%}%>>ȭ��2(��ȭ��)</option>			  			  
              <option value="803" <%if(gubun3.equals("803")){%>selected<%}%>>ȭ��3(1������,��)</option>	
              <option value="811" <%if(gubun3.equals("811")){%>selected<%}%>>ȭ��4(2.5������)</option>			  			  
              <option value="821" <%if(gubun3.equals("821")){%>selected<%}%>>ȭ��5(5������)</option>	
              <option value="01" <%if(gubun3.equals("01")){%>selected<%}%>>�Ƹ���ī�Ǻ�����</option>	
              <option value="02" <%if(gubun3.equals("02")){%>selected<%}%>>���Ǻ�����</option>
              <option value="0038" <%if(gubun3.equals("0038")){%>selected<%}%>>����ī��������</option>	
              <option value="0008" <%if(gubun3.equals("0008")){%>selected<%}%>>DB���غ���</option>
			  
            </select>
		<!--<a href="javascript:Search(1)"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a>--></td>
    </tr>
    <tr> 
        <td colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;  
            <select name="s_kd">
              <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>��ü</option>
              <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>��ȣ</option>
              <option value="4" <%if(s_kd.equals("4")){%> selected <%}%>>����ȣ</option>
              <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>������ȣ</option>
              <option value="3" <%if(s_kd.equals("3")){%> selected <%}%>>�����ȣ</option>
              <option value="5" <%if(s_kd.equals("5")){%> selected <%}%>>����</option>
	      <option value="6" <%if(s_kd.equals("6")){%> selected <%}%>>�����з�</option>
	      <option value="9" <%if(sort.equals("9")){%> selected <%}%>>���������</option>
	      <option value="7" <%if(sort.equals("7")){%> selected <%}%>>���踸����</option>
	       <option value="8" <%if(sort.equals("8")){%> selected <%}%>>����ȸ��</option>
            </select>&nbsp;
            <input type="text" name="t_wd" size="23" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()">
        </td>
        <td colspan="2"><img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
            <select name="sort">
              <option value="1" <%if(sort.equals("1")){%> selected <%}%>>���������</option>
              <option value="6" <%if(sort.equals("6")){%> selected <%}%>>���踸����</option>
              <option value="2" <%if(sort.equals("2")){%> selected <%}%>>��ȣ</option>
              <option value="3" <%if(sort.equals("3")){%> selected <%}%>>������ȣ</option>
              <option value="4" <%if(sort.equals("4")){%> selected <%}%>>����</option>
              <option value="5" <%if(sort.equals("5")){%> selected <%}%>>����ȸ��</option>
              <option value="7" <%if(sort.equals("7")){%> selected <%}%>>�����з�</option>			  
            </select>
            <input type='radio' name='asc' value='asc'  onClick='javascript:Search()' <%if(asc.equals("asc")){%> checked <%}%>>
            �������� 
            <input type='radio' name='asc' value='desc' onClick='javascript:Search()' <%if(asc.equals("desc")){%> checked <%}%>>
            �������� </td>
        <td><a href="javascript:Search(3)"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a> 		
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<!--<a href="javascript:list_print()"><img src="/acar/images/center/button_print.gif"  align="absmiddle" border="0"></a>-->
		*������
		<select name="mod_st">
                    <option value="1">1��</option>
                    <option value="2">2��</option>
                    <option value="3">3��</option>
                    <option value="4">4��</option>
                    <option value="5">5��</option>
                    <option value="6">6��</option>
                    <option value="7">7��</option>
                    <option value="8">8��</option>
                    <option value="9">9��</option>
                    <option value="10">10��</option>                    
                </select>
		<a href="javascript:list_excel()"><img src="/acar/images/center/button_excel.gif"  align="absmiddle" border="0"></a> 	
		&nbsp;	
		<a href="javascript:list_excel_0038()">[�������ս�û��]</a> 		
        </td>
    </tr>
</table>
</form>
</body>
</html>