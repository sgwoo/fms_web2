<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = a_db.getRentBoardList(s_kd, t_wd, gubun1, gubun2, st_dt, end_dt, sort, asc);
	int vt_size = vt.size();
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+					
				   	"&sh_height="+sh_height+"";
	
%>

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
	
	//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}
	
	//��ĵ���
	function scan_file(tint_st, content_code, content_seq){
		window.open("/fms2/car_tint/reg_scan.jsp<%=valus%>&tint_st="+tint_st+"&content_code="+content_code+"&content_seq="+content_seq, "SCAN", "left=300, top=300, width=720, height=300, scrollbars=yes, status=yes, resizable=yes");
	}
					
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>  
  <input type='hidden' name='sort' 	value='<%=sort%>'>  
  <input type='hidden' name='asc' 	value='<%=asc%>'>      
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='mod_st' value='1'>
  <input type='hidden' name='ins_com_id' value=''>
  <input type='hidden' name='from_page' value='/fms2/car_pur/pur_doc_frame.jsp'>
<div style="overflow:auto">  
<table border="0" cellspacing="0" cellpadding="0" width='2240'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='500' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr>
			        <td width='30' class='title' style='height:51'>����</td>
					<td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>				  									
					<td width='60' class='title'>����</td>
	                <td width="110" class='title'>����ȣ</td>
	                <td width="150" class='title'>��</td>
	                <td width="60" class='title'>���ʿ���</td>
	                <td width="60" class='title'>�������<br>�����</td>
			    </tr>
			</table>
		</td>
		<td class='line' width='1740'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td colspan="5" class='title'>���ʻ���</td>					
				  <td colspan="5" class='title'>�������</td>
				  <td colspan="7" class='title'>�������</td>				  
				  <td colspan="2" class='title'>���ڽ�</td>				  
				  <td colspan="2" class='title'>�����</td>				  
				</tr>
				<tr>
			      <td width='50' class='title'>�뵵</td>
			      <td width='90' class='title'>����</td>
			      <td width='70' class='title'>��������</td>				  
				  <td width='60' class='title'>�������</td>
				  <td width='80' class='title'>�μ���</td>	
			      <td width='120' class='title'>�����ȣ</td>				  
			      <td width='90' class='title'>�����</td>
			      <td width='100' class='title'>����ó</td>				  
			      <td width='90' class='title'>�����</td>				  
				  <td width='90' class='title'>�μ�������</td>
				  <td width='90' class='title'>��������</td>
				  <td width='80' class='title'>������ȣ</td>
				  <td width='140' class='title'>�����ȣ</td><!-- 2017. 12. 11 ��ġ ���� -->
				  <td width='40' class='title'>����</td><!-- 2017. 12. 11 ���� -->
				  <td width='90' class='title'>�������</td><!-- 2017. 12. 11 ��ġ ���� -->
				  <td width='100' class='title'>��漼���Ǻ���</td>
				  <td width='100' class='title'>��ǰ��</td>			  				  			  
			      <td width='40' class='title'>����</td>
			      <td width='100' class='title'>������</td>				  				  				  				  
			      <td width='60' class='title'>�뿩����</td>
			      <td width='60' class='title'>�������</td>				  				  				  				  
			  </tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='500' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td  width='30' align='center'><%=i+1%></td><!-- ���� -->
					<td  width='30' align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("RENT_L_CD")%>"></td><!-- �� -->										
					<td  width='60' align='center'><%//=ht.get("SORT1")%><%//=ht.get("SORT2")%><%//=ht.get("SORT3")%><%=ht.get("RENT_ST")%></td><!-- ���� -->
					<td  width='110' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td><!-- ����ȣ -->	
					<td  width='150' align='center'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 8)%><span title='<%=ht.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '1', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"></a></span></td><!-- �� -->
					<td  width='60' align='center'>
					  	<%-- <a href="javascript:parent.req_fee_start_act('���� ������ �԰� �뺸', '<%=ht.get("RPT_NO")%> | <%=ht.get("FIRM_NM")%> | <%=ht.get("CAR_NM")%><%if(String.valueOf(ht.get("CAR_NO")).length()==7){%> | <%=ht.get("CAR_NO")%><%}%> ����. 2��30�п� Ź�ۺ�������.', '<%=ht.get("BUS_ID")%>', '<%=ht.get("AGENT_EMP_NM")%>', '<%=ht.get("AGENT_EMP_M_TEL")%>','<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='���ʿ����ڿ��� ���� ������ �԰� �뺸�ϱ�'> --%>
					  	<a href="javascript:parent.req_fee_start_act2('���� ������ �԰� �뺸', '<%=ht.get("RPT_NO")%> | <%=ht.get("FIRM_NM")%> | <%=ht.get("CAR_NM")%><%if(String.valueOf(ht.get("CAR_NO")).length()==7||String.valueOf(ht.get("CAR_NO")).length()==8){%> | <%=ht.get("CAR_NO")%><%}%> ����. 2��30�п� Ź�ۺ�������.', '<%=ht.get("RPT_NO")%>', '<%=ht.get("FIRM_NM")%>', '<%=ht.get("CAR_NM")%>', '<%if (String.valueOf(ht.get("CAR_NO")).length() == 7 || String.valueOf(ht.get("CAR_NO")).length() == 8) {%><%=ht.get("CAR_NO")%><%}%>', '<%=ht.get("BUS_ID")%>', '<%=ht.get("AGENT_EMP_NM")%>', '<%=ht.get("AGENT_EMP_M_TEL")%>','<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='���ʿ����ڿ��� ���� ������ �԰� �뺸�ϱ�'>
					    	<%=ht.get("BUS_NM")%>
					  	</a>
					</td><!-- ���ʿ��� -->
					<td  width='60' align='center'><span title='<%=ht.get("AGENT_EMP_M_TEL")%>'><%=ht.get("AGENT_EMP_NM")%></span></td><!-- ������� ����� -->
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='1740'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
				<tr>
					<td  width='50' align='center'><%if(String.valueOf(ht.get("CAR_ST")).equals("����")){%><font color=red><%}%><%if(String.valueOf(ht.get("CAR_ST")).equals("�����뿩")){%>��Ʈ<%}else{%><%=ht.get("CAR_ST")%><%}%><%if(String.valueOf(ht.get("CAR_ST")).equals("����")){%></font><%}%></td><!-- �뵵 -->
					<td  width='90' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td><!-- ���� -->
					<td  width='70' align='center'>
						<%if(String.valueOf(ht.get("ECO_E_TAG")).equals("1")){%>
						�߱�
						<%}%>
					</td><!-- ���� ���� -->
					<td  width='60' align='center'><%=ht.get("CAR_EXT")%></td><!-- ������� -->	
					<td  width='80' align='center'><%=ht.get("UDT_ST")%></td><!-- �μ��� -->

					<td  width='120' align='center'><%=ht.get("RPT_NO")%></td><!-- �����ȣ -->	
					<td  width='90' align='center'>
						<%if(String.valueOf(ht.get("DLV_BRCH")).equals("B2B������")||String.valueOf(ht.get("DLV_BRCH")).equals("����������")||String.valueOf(ht.get("DLV_BRCH")).equals("�����Ǹ���")||String.valueOf(ht.get("DLV_BRCH")).equals("Ư����")){%>
						  <font color=red><span title='<%=ht.get("DLV_BRCH")%>'><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 5)%></span></font>
						<%}else{%>  
						  <span title='<%=ht.get("DLV_BRCH")%>'><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 5)%></span>
						<%}%>
					</td><!-- ����� -->
					<td  width='100' align='center' style="font-size:11px;"><%=ht.get("CAR_OFF_TEL")%></td><!-- ����ó -->
					<td  width='90' align='center'><%=Util.subData(String.valueOf(ht.get("DLV_EXT")), 5)%></td><!-- ����� -->
					<td  width='90' align='center'><a href="javascript:parent.view_est('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("UDT_EST_DT")))%></a></td><!-- �μ������� -->	
					
					
					<td  width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_PAY_DT")))%>
					<%if(String.valueOf(ht.get("PUR_PAY_DT")).equals("") && !String.valueOf(ht.get("DOC_USER_DT2")).equals("")){%>
					<%=AddUtil.ChangeDate2(String.valueOf(ht.get("DOC_USER_DT2")))%>
					<%}%>
					</td><!-- �������� -->
					<td  width='80' align='center'> <%if(String.valueOf(ht.get("INIT_REG_DT")).equals("")){%><a href="javascript:parent.reg_estcarno ('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_ST")%>','<%=ht.get("UDT_ST")%>');"><%=ht.get("CAR_NO")%> </a><%if(String.valueOf(ht.get("CAR_NO")).equals("")){%><a href="javascript:parent.reg_estcarno('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_ST")%>','<%=ht.get("UDT_ST")%>');" class="btn"><img src=/acar/images/center/button_in_hmnum.gif align=absmiddle border=0></a><%}%><%}else{%><%=ht.get("CAR_NO")%><%}%></td><!-- ������ȣ -->
					<td  width='140' align='center'><%if(String.valueOf(ht.get("INIT_REG_DT")).equals("")){%><a href="javascript:parent.reg_estcarnum('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');"><%=ht.get("CAR_NUM")%></a><%if(String.valueOf(ht.get("CAR_NUM")).equals("")){%><a href="javascript:parent.reg_estcarnum('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" class="btn"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a><%}%><%}else{%><%=ht.get("CAR_NUM")%><%}%></td><!-- �����ȣ -->
					<td  width='40' align='center'><%if(String.valueOf(ht.get("ARRIVAL_DT")).equals("")){%><%}else{%><span title='<%=ht.get("ARRIVAL_DT")%>'>��</span><%}%></td><!-- ���� 2017. 12. 11 ���� -->
					<td  width='90' align='center'><%if(String.valueOf(ht.get("INIT_REG_DT")).length()>0){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%><%}else{%><a href="javascript:parent.carRegList('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("REG_GUBUN")%>','<%=ht.get("UDT_ST")%>');" class="btn"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a><%}%></td><!-- ������� 2017. 12. 11 ��ġ���� -->
					<td  width='100' align='center'><%if(String.valueOf(ht.get("ACQ_CNG_YN")).equals("����")){%><span title='<%=c_db.getNameById(String.valueOf(ht.get("CPT_CD")),"BANK")%>'><%=Util.subData(c_db.getNameById(String.valueOf(ht.get("CPT_CD")),"BANK"), 6)%></span><%}%></td><!-- ��漼���Ǻ��� -->
					<td  width='100' align='center'><span title='<%=ht.get("RENT_EXT")%>'><%=Util.subData(String.valueOf(ht.get("RENT_EXT")), 6)%></span></td><!-- ��ǰ�� -->
						
					<td  width='40' align='center'>
					<%if(String.valueOf(ht.get("TINT_NO2")).equals("")){%>
                                        <%=ht.get("BLACKBOX_YN_NM")%>
					<%}else{%>
					<%=ht.get("B_YN")%>
					<%}%>					
					</td><!-- ���� -->
					<td  width='100' align='center' style="font-size : 8pt;">
					<%if(!String.valueOf(ht.get("TINT_NO2")).equals("")){%>					    
					<span title='<%=ht.get("B_COM_NM")%>'><%=Util.subData(String.valueOf(ht.get("B_COM_NM")), 5)%></span>
					<%}%>						    
					</td><!-- ������ -->					
					<td  width='60' align='center'><%if(String.valueOf(ht.get("RENT_WAY")).equals("�Ϲݽ�")){%><font color=red><%}%><%=ht.get("RENT_WAY")%><%if(String.valueOf(ht.get("RENT_WAY")).equals("�Ϲݽ�")){%></font><%}%></td><!-- �뿩���� -->					
					<td  width='60' align='center'><%=ht.get("MNG_NM")%></td><!-- ������� -->
				</tr>
<%
		}
%>
			</table>
		</td>
<%	}                  
	else               
	{
%>                     
	<tr>
		<td class='line' width='450' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>�˻�� �Է��Ͻʽÿ�.
					<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1650'>
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
</div>
</form>

<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

