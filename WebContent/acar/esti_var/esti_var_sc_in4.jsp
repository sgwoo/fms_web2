<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiSikVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	//������ �ܰ�����
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	Vector vt = e_db.getEstiShVarList();
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//������ ����
	function view_sh_var(sh_code, seq){
		var SUBWIN="./esti_sh_var_i.jsp?sh_code="+sh_code+"&seq="+seq;	
		window.open(SUBWIN, "SHVar", "left=50, top=50, width=750, height=600, scrollbars=yes");
	}

	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post' target='t_content'>
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="a_a" value="<%//=bean.getA_a()%>">          
  <input type="hidden" name="seq" value="<%//=bean.getSeq()%>">          
  <input type="hidden" name="cmd" value="">
  <input type='hidden' name='vt_size' value='<%=vt_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1210'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='340'>
                <tr> 
                    <td width='30' class='title' style='height:45;'>����</td>
                    <td width='80' class='title'>�����ڵ�</td>
                    <td width='150' class='title'>����</td>
                    <td width='80' class='title'>����24����<br>�ܰ���</td>
                </tr>
            </table>
        </td>
        <td class='line' width='870'>
	        <table border="0" cellspacing="1" cellpadding="0" width='870'>
                <tr> 
                    <td width='60' rowspan="2" class='title'>¤<br>����</td>
                    <td width='60' rowspan="2" class='title'>LPG<br>����</td>
                    <td width='60' rowspan="2" class='title'>7~9�ν�<br>����</td>
                    <td colspan="3" class='title' width=240>LPGŰƮ</td>
                    <td colspan="2" class='title' width=160>Ź�۷�</td>
                    <td colspan="3" class='title' width=210>�Һ�������</td>
                    <td width='80' rowspan="2" class='title'>��������</td>
                </tr>
                <tr>
                    <td width='80' class='title'>�������ɿ���</td>
                    <td width='80' class='title'>��/Ż�����</td>
                    <td width='80' class='title'>�����л�</td>
                    <td width='80' class='title'>����</td>
                    <td width='80' class='title'>�λ�</td>
                    <td width='70' class='title'>12/24����</td>
                    <td width='70' class='title'>36����</td>
                    <td width='70' class='title'>48/60����</td>
                </tr>
            </table>
        </td>
    </tr>
<%	if(vt_size > 0){%>
    <tr>
	    <td class='line' width='340' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='340'>
          <%for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td width='30' align='center'><a name="<%=i+1%>"><%=i+1%></a></td>
                    <td width='80' align='center'><a href="javascript:view_sh_var('<%=ht.get("SH_CODE")%>','<%=ht.get("SEQ")%>')" onMouseOver="window.status=''; return true"><%=ht.get("SH_CODE")%></a></td>
                    <td width='150' align='center'><span title='<%=ht.get("CARS")%>'><%=AddUtil.subData(String.valueOf(ht.get("CARS")), 12)%></span></td>			
                    <td width='80' align='center'><%=ht.get("JANGA24")%>%</td>
                </tr>
          <%}%>
            </table>
	    </td>
	    <td class='line' width='870'>
	        <table border="0" cellspacing="1" cellpadding="0" width='870'>
          <%for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td width='60' align="center"><%=ht.get("JEEP_YN")%></td>
                    <td width='60' align="center"><%=ht.get("RENTCAR")%></td>
                    <td width='60' align="center"><%=ht.get("SVN_NN_YN")%></td>
                    <td width='80' align="center"><%=ht.get("LPG_GA_YN")%></td>
                    <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("LPG_AMT")))%>��&nbsp;</td>
                    <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("LPG_ADD_AMT")))%>��&nbsp;</td>
                    <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TAKSONG_SE")))%>��&nbsp;</td>
                    <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TAKSONG_BU")))%>��&nbsp;</td>
                    <td width='70' align='center'><%=ht.get("AF_M12_24")%>%</td>
                    <td width='70' align='center'><%=ht.get("AF_M36")%>%</td>
                    <td width='70' align='center'><%=ht.get("AF_M48_60")%>%</td>
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                </tr>
            <%}%>
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='340' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='340'>
                <tr> 
                    <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
            </table>
        </td>
        <td class='line' width='870'>
	        <table border="0" cellspacing="1" cellpadding="0" width='870'>
                <tr>
		            <td>&nbsp;</td>
	            </tr>
	        </table>
        </td>
    </tr>
<% 	}%>
</table>
</form>
</body>
</html>
