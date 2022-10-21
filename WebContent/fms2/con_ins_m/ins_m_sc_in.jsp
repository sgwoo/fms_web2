<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_accident.*"%>
<jsp:useBean id="aim_db" scope="page" class="acar.con_ins_m.AddInsurMDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	String rent="";
	int total_su = 0;
	long total_amt = 0;	
	long total_amt2 = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarAccidDatabase a_cad = AddCarAccidDatabase.getInstance();
	
	Vector ins_ms = ae_db.getInsurMList(br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int ins_m_size = ins_ms.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=ins_m_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1500'>
    <tr>
        <td colspan=2 class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='33%' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=11% class='title'>����</td>
                    <td width=11% class='title'>����</td>
                    <td width=20% class='title'>����ȣ</td>
                    <td width=30% class='title'>��ȣ</td>
                    <td width=18% class='title'>������ȣ</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='67%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=14% class='title'>����</td>
                    <td width=8% class='title'>���񱸺�</td>
                    <td width=15% class='title'>�����ü</td>
                    <td width=10% class='title'>����ݾ�</td>
                    <td width=10% class='title'>û���ݾ�</td>
                    <td width=8% class='title'>�Աݿ�����</td>
                    <td width=5% class='title'>ȸ��</td>
					<td width=8% class='title'>��꼭����</td>
                    <td width=8% class='title'>��������</td>
                    <td class='title' width=7%>��ü�ϼ�</td>
                    <td class='title' width=7%>���������</td>
                </tr>
            </table>
	    </td>
    </tr>
<%	if(ins_m_size > 0){%>
    <tr>
	    <td class='line' width='33%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for (int i = 0 ; i < ins_m_size ; i++){
			Hashtable ins_m = (Hashtable)ins_ms.elementAt(i);%>
                <tr> 
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> width=11% align='center'><a name="<%=i+1%>"><%=i+1%> 
                      <%if(ins_m.get("USE_YN").equals("N")){%>
                      (�ؾ�) 
                      <%}%>
                      </a></td>
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> width=11% align='center'><a href="javascript:parent.view_memo('<%=ins_m.get("RENT_MNG_ID")%>','<%=ins_m.get("RENT_L_CD")%>','<%=ins_m.get("CAR_MNG_ID")%>','1','<%=ins_m.get("ACCID_ID")%>','<%=ins_m.get("SERV_ID")%>','<%=ins_m.get("MNG_ID")%>')" onMouseOver="window.status=''; return true" title="<%=a_cad.getMaxMemo(String.valueOf(ins_m.get("RENT_MNG_ID")), String.valueOf(ins_m.get("RENT_L_CD")), "1", "", "")%>"><%=ins_m.get("GUBUN")%></a></td>
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> width=20% align='center'><a href="javascript:parent.view_ins_m('<%=ins_m.get("RENT_MNG_ID")%>','<%=ins_m.get("RENT_L_CD")%>','<%=ins_m.get("CAR_MNG_ID")%>','<%=ins_m.get("ACCID_ID")%>','<%=ins_m.get("SERV_ID")%>', '<%=i%>')" onMouseOver="window.status=''; return true"><%=ins_m.get("RENT_L_CD")%></a></td>
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> width=30% align='center'> 
                      <%if(ins_m.get("FIRM_NM").equals("(��)�Ƹ���ī") && !ins_m.get("CUST_NM").equals("")){%>
                      <span title='(<%=ins_m.get("RES_ST")%>)<%=ins_m.get("CUST_NM")%>'><a href="javascript:parent.view_client('<%=ins_m.get("RENT_MNG_ID")%>','<%=ins_m.get("RENT_L_CD")%>','<%=ins_m.get("RENT_ST")%>')" onMouseOver="window.status=''; return true">(<%=ins_m.get("RES_ST")%>)<%=Util.subData(String.valueOf(ins_m.get("CUST_NM")), 6)%></a></span> 
                      <%}else{%>
                      <span title='<%=ins_m.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=ins_m.get("RENT_MNG_ID")%>','<%=ins_m.get("RENT_L_CD")%>','<%=ins_m.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(ins_m.get("FIRM_NM")), 10)%></a></span> 
                      <%}%>
                    </td>
                    <td width=18% align='center' <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%>><span title='<%=ins_m.get("CAR_NO")%>'><%=Util.subData(String.valueOf(ins_m.get("CAR_NO")), 15)%></span></td>
                </tr>
                <%	}%>
                <tr> 
                    <td class="title" align='center'></td>		  
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title" align='center'>�հ�</td>			
                    <td class="title">&nbsp;</td>			
                </tr>
            </table>
        </td>
	    <td class='line' width='67%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%		for (int i = 0 ; i < ins_m_size ; i++){
			    Hashtable ins_m = (Hashtable)ins_ms.elementAt(i);
			    //��ü�� �ϰ� ����
		   	    boolean flag = aim_db.calDelay((String)ins_m.get("RENT_MNG_ID"), (String)ins_m.get("RENT_L_CD"), (String)ins_m.get("CAR_MNG_ID"));%>
                <tr> 
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> width=14% align='center' height="40"><span title='<%=ins_m.get("CAR_NM")%> <%=ins_m.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(ins_m.get("CAR_NM"))+" "+String.valueOf(ins_m.get("CAR_NAME")), 9)%></span></td>
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> width=8% align='center' height="40"><%=ins_m.get("SERV_ST")%></td>
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> width=15% align='center' height="40"><span title='<%=ins_m.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ins_m.get("OFF_NM")), 7)%></span></td>
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> width=10% align='right' height="40"><%=Util.parseDecimal(String.valueOf(ins_m.get("TOT_AMT")))%>��&nbsp;</td>
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> width=10% align='right' height="40"><%=Util.parseDecimal(String.valueOf(ins_m.get("CUST_AMT")))%>��&nbsp;</td>
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> width=8% align='center' height="40"><%=ins_m.get("CUST_PLAN_DT")%></td>
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> width=5% align='center' height="40"><%=ins_m.get("EXT_TM")%><%=ins_m.get("TM_ST")%>ȸ</td>
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> width=8% align='center' height="40"><%=AddUtil.ChangeDate2(String.valueOf(ins_m.get("EXT_DT")))%></td>
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> width=8% align='center' height="40"><%=ins_m.get("CUST_PAY_DT")%></td>					
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> align='right' width=7% height="40"><%=Util.parseDecimal(String.valueOf(ins_m.get("DLY_DAYS")))%>��&nbsp;</td>
                    <td <%if(ins_m.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width=7% height="40"><%=c_db.getNameById(String.valueOf(ins_m.get("BUS_ID2")), "USER")%></td>
                </tr>
                <%
				        total_su = total_su + 1;
				        total_amt = total_amt + Long.parseLong(String.valueOf(ins_m.get("CUST_AMT")));
				        total_amt2 = total_amt2 + Long.parseLong(String.valueOf(ins_m.get("TOT_AMT")));
		  		        }%>
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%>��&nbsp;</td>			
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>��&nbsp;</td>			
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>					
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>			
                    <td class="title">&nbsp;</td>						
                </tr>
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='33%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='67%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
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
