<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String agent_user_id = "";
	
	if( acar_de.equals("1000")) agent_user_id = ck_acar_id;
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt = d_db.getSucCommiDocList(s_kd, t_wd, gubun1, agent_user_id);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>	
<script language='javascript'>
<!--
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
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<body onLoad="javascript:init()">
    <table border="0" cellspacing="0" cellpadding="0" width='1080'>
        <tr>
            <td class=line2 colspan="2"></td>
        </tr>
        <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='560' id='td_title' style='position:relative;'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		    <tr>
		        <td width='30' class='title' style='height:51'>����</td>
			      <td width='30' class='title'>����</td>
		        <td width='100' class='title'>����ȣ</td>
        		<td width='75' class='title'>�°���</td>
		        <td width="200" class='title'>��</td>
		        <td width="75" class='title'>������ȣ</td>
		        <td width="50" class='title'>�����</td>
		    </tr>
		</table>
	    </td>
	    <td class='line' width='520'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		    <tr>
			<td colspan="3" class='title'>�߽�ó</td>
			<td colspan="3" class='title'>����ó</td>
			<td colspan="2" class='title'>�°������</td>
		    </tr>
		    <tr>
			<td width='80' class='title'>�������</td>
			<td width='60' class='title'>�����</td>			
			<td width='60' class='title'>����</td>
			<td width='60' style="font-size:7pt" class='title'>ȸ�����</td>
			<td width='60' style="font-size:7pt" class='title'>ä�ǰ���</td>
			<td width='60' class='title'>����</td>
			<td width='60' class='title'>�ݾ�</td>
			<td width='80' class='title'>�Ա���</td>
		    </tr>
		</table>
	    </td>
        </tr>
<%
	if(vt_size > 0)
	{
%>
        <tr>
	    <td class='line' width='560' id='td_con' style='position:relative;'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			if(String.valueOf(ht.get("RENT_L_CD")).equals("G117KYPR00354")
					   ) continue;
			
			
			
			int e_doc = 0;
			if(gubun1.equals("1")){
				//���ڰ�༭ �߼�(�Ϸ����ڰ��Ǹ�)������ üũ(20190822) -> 20211108 �������� -> 20211222 �������� ǰ, Ư������ȣ�� ���� 
				Vector vt_alink = ln_db.getAlinkSendLCList("2", String.valueOf(ht.get("RENT_L_CD")), "", "", "2", "", "1", "6", "20000101", "99999999");
				e_doc = vt_alink.size();
			}	
			
			if(e_doc == 0){				
				count++;				
%>
    <tr>
			<td  width='30' align='center'><%=count%></td>
			<td  width='30' align='center'><%=ht.get("BIT")%></td>
			<td  width='100' align='center'><%=ht.get("RENT_L_CD")%></td>
			<td  width='75' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_SUC_DT")))%></td>
			<td  width='200'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.substringbdot(String.valueOf(ht.get("FIRM_NM")), 22)%></a></span></td>
			<td  width='75' align='center'><%=ht.get("CAR_NO")%></td>			
			<td  width='50' align='center'><%=c_db.getNameById(String.valueOf(ht.get("BUS_ID")),"USER")%></td>					
    </tr>
<%			}
		}
%>
		</table>
	    </td>
	    <td class='line' width='520'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			if(String.valueOf(ht.get("RENT_L_CD")).equals("G117KYPR00354")
					   ) continue;
			
			int e_doc = 0;
			if(gubun1.equals("1")){
				//���ڰ�༭ �߼�(�Ϸ����ڰ��Ǹ�)������ üũ(20190822)
				Vector vt_alink = ln_db.getAlinkSendLCList("2", String.valueOf(ht.get("RENT_L_CD")), "", "", "2", "", "1", "6", "20000101", "99999999");
				e_doc = vt_alink.size();
			}	
			
			if(e_doc == 0){							
%>			
		    <tr>
			<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USER_DT1")))%></td>		    	
		        <!--�����-->
			<td  width='60' align='center'>			    
			    <%	if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
			    <%		if(!user_id.equals(String.valueOf(ht.get("�Ƹ���ī�̿�")))){%>
						<a href="javascript:parent.commi_action('1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gian.gif"  border="0" align=absmiddle></a>
			    <%		}else{%>-<%}%>
			    <%	}else{%>
			    			<a href="javascript:parent.commi_action('1', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID1")),"USER")%></a>
			    <%	}%>
			</td>
			<!--��� ����-->  
			<td  width='60' align='center'>
			    <%	if(!String.valueOf(ht.get("USER_ID3")).equals("XXXXXX")){%> 		
			    <%		if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT3")).equals("")){%>
			    <%			if(String.valueOf(ht.get("USER_ID3")).equals(user_id) || nm_db.getWorkAuthUser("������",user_id)){%>
  						<a href="javascript:parent.commi_action('3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
			    <%			}else{%>-<%}%>
			    <%		}else{%><a href="javascript:parent.commi_action('3', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID3")),"USER")%></a>
			    <%		}%>
			    <%	}else{%>-<%}%>
			</td>
			<!--ȸ�������-->
			<td  width='60' align='center'>
			    <%	if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT6")).equals("")){%>
			    <%		if(String.valueOf(ht.get("USER_ID6")).equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) || nm_db.getWorkAuthUser("ä�ǰ�����",user_id)){%>
			 		  	<a href="javascript:parent.commi_action('6', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
			    <%		}else{%>-<%}%>
			    <%	}else{%>	<a href="javascript:parent.commi_action('6', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID6")),"USER")%></a>
			    <%	}%>
			</td>
			<!--ä�ǰ�����-->
			<td  width='60' align='center'>
			    <%	if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT7")).equals("")){%>
			    <%		if(String.valueOf(ht.get("USER_ID7")).equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������",user_id)){%>
					  	<a href="javascript:parent.commi_action('7', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
			    <%		}else{%>-<%}%>
			    <%	}else{%>	<a href="javascript:parent.commi_action('7', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID7")),"USER")%></a>
			    <%	}%>
			</td>
			<!--�ѹ�����-->  
			<td  width='60' align='center'>
			    <%	if(!String.valueOf(ht.get("USER_ID8")).equals("XXXXXX")){%> 	
			    <%		if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT8")).equals("")){%>
			    <%			if(String.valueOf(ht.get("USER_ID8")).equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������",user_id)){%>
			  	  		<a href="javascript:parent.commi_action('8', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif"  border="0" align=absmiddle></a>
			    <%			}else{%>-<%}%>
			    <%		}else{%><a href="javascript:parent.commi_action('8', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("DOC_NO")%>');"><%=c_db.getNameById(String.valueOf(ht.get("USER_ID8")),"USER")%></a>
			    <%		}%>
			    <%	}else{%>-<%}%>
			</td>
			<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("EXT_AMT")))%></td>
			<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXT_PAY_DT")))%></td>
		    </tr>
<%			}
		}
%>
		</table>
	    </td>
<%	}                  
	else               
	{
%>                     
	<tr>
	    <td class='line' width='560' id='td_con' style='position:relative;'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		    <tr>
			<td align='center'>
					<%if(t_wd.equals("")){%>�˻�� �Է��Ͻʽÿ�.
					<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='520'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=count%>';
//-->
</script>
</body>
</html>
