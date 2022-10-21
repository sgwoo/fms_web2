<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.asset.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String asset_code = request.getParameter("asset_code")==null?"":request.getParameter("asset_code");
	
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	AssetDatabase a_db = AssetDatabase.getInstance();
	
	Vector vt = new Vector();
	vt = a_db.getAssetMoveList(asset_code);
	
	int cont_size = vt.size();
	
	long t_amt1[] = new long[1];  //���ʰ���
    long t_amt2[] = new long[1];  //��� ����
    long t_amt3[] = new long[1];  //���� ����
    long t_amt4[] = new long[1];  // ��� ����
    long t_amt5[] = new long[1];  //���� ����
    long t_amt6[] = new long[1];  //���⸻ ����
    long t_amt7[] = new long[1];  //��⸻�� ��ΰ���
    long t_amt8[] = new long[1];
    long t_amt9[] = new long[1];
    long t_amt10[] = new long[1];
  	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	/* Title ���� */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr><td class=line2></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1' >		
        <td class='line' width='100%' id='td_title' style='position:relative;' > 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=43>
                <tr> 
                  <td width='6%' class='title'>����</td>
                  <td width='12%' class='title'>��������</td>
                  <td width='15%' class='title'>��������</td>
                  <td width='25%' class='title'>����</td>
                  <td width='15%' class='title'>���ݾ�</td>
                  <td width='12%' class='title'>ó�м���</td>
                  <td width="15%" class='title'>ó�бݾ�</td>
                </tr>
            </table>
	    </td>	
    </tr>
  <%if(cont_size > 0){%>
    <tr>		
        <td class='line' width='100%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
				if(!String.valueOf(ht.get("DEPRF_YN")).equals("3")) td_color = "class='is'";
	
				long t1=0;
				long t2=0;
				long t3=0;
			
												
			       t1 = AddUtil.parseLong(String.valueOf(ht.get("CAP_AMT")));
			    
                t2 = AddUtil.parseLong(String.valueOf(ht.get("SALE_QUANT")));
                t3 = AddUtil.parseLong(String.valueOf(ht.get("SALE_AMT")));
             	 
			
				for(int j=0; j<1; j++){
				
				      if (   !ht.get("MA_CHK").equals("G") )  { //���κ�����
				        		t_amt1[j] += t1;
				      }
				      					
						t_amt2[j] += t2;
						t_amt3[j] += t3;
													
				}
	
		%>
                <tr> 
                  <td <%=td_color%> width='6%' align='center'><%=i+1%></td>
                  <td <%=td_color%> width='12%' align='center'><!--<a href="javascript:parent.view_asset('<%=ht.get("ASSET_CODE")%>', '<%=ht.get("ASSCH_SERI")%>')" onMouseOver="window.status=''; return true">--><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ASSCH_DATE")))%></a></td>
                  <td <%=td_color%> width='15%' align='center'>
                  <%    if (ht.get("ASSCH_TYPE").equals("1")){%>�ں������� <%}else if( ht.get("ASSCH_TYPE").equals("2")){%>���������� <%}else if( ht.get("ASSCH_TYPE").equals("3")){%>�Ű�/��� <%}else if( ht.get("ASSCH_TYPE").equals("4")){%>�̵� <%}else if( ht.get("ASSCH_TYPE").equals("5")){%>���� <%}%>
                  
                  </td>
                  <td <%=td_color%> width='25%' align='center'><%=ht.get("ASSCH_RMK")%></td>		
                  <td <%=td_color%> width="15%" align='right'><%=Util.parseDecimal(t1)%>&nbsp;</td>
                  <td <%=td_color%> width="12%" align='right'><%=Util.parseDecimal(t2)%>&nbsp;</td>
                  <td <%=td_color%> width="15%" align='right'><%=Util.parseDecimal(t3)%>&nbsp;</td>
                </tr>
                <%		}	%>
                <tr> 
                    <td class=title colspan="4" align="center">�հ�</td>
                    <td class=title style='text-align:right'><%=Util.parseDecimal(t_amt1[0])%>&nbsp;</td>	
                    <td class=title style='text-align:right'><%=Util.parseDecimal(t_amt2[0])%>&nbsp;</td>			
                    <td class=title style='text-align:right'><%=Util.parseDecimal(t_amt3[0])%>&nbsp;</td>			
                 </tr>
            </table>
	    </td>
<%	}else{	%>                     
    <tr>		
        <td class='line' width='100%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'><%if(asset_code.equals("")){%>�˻�� �Է��Ͻʽÿ�.<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
                </tr>
            </table>
	    </td>

    </tr>
<%	}	%>
</table>
</body>
</html>


