<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*, acar.consignment.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "07", "04");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 1; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&gubun6="+gubun6+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"";
					
	
	
	Vector vt = cs_db.getConsignmentPurStatList(s_kd, t_wd, gubun1, gubun2, st_dt, end_dt);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;

	int total_cnt1	= 0;
	int total_cnt2 = 0;
	int total_cnt3	= 0;
	int total_cnt4 = 0;
	int total_cnt5 = 0;
	int total_cnt6 = 0;

%>
<html>
<head><title>FMS</title>
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
<body leftmargin="15"  onLoad="javascript:init()">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/cons_pur/consp_stat_frame.jsp'>
  <input type='hidden' name='idx'  value=''>
  <input type='hidden' name='mode' value=''>      
<table border="0" cellspacing="0" cellpadding="0" width=1630>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='380' id='td_title' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='100' rowspan="3" class='title'>������</td>
		    <td width='60' rowspan="3" class='title'>&nbsp;<br>���<br>&nbsp;<br>�繫��<br>&nbsp;</td>
		    <td width="100" rowspan="3" class='title'>Ź�۾�ü</td>				  				  
                    <td width="120" rowspan="3" class='title'>����</td>
	    </table>
	</td>
	<td class='line' width='1250'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>                    				  				  		    
		    <td colspan="17" class='title'>�μ���</td>
		</tr>
		<tr>
		  <td colspan="3" class='title'>����</td>		    
		    <td colspan="3" class='title'>�λ�</td>		    
		    <td colspan="3" class='title'>����</td>
		    <td colspan="3" class='title'>�뱸</td>			
		    <td colspan="3" class='title'>����</td>			
		    <td colspan="2" class='title'>�հ�</td>			
		</tr>
		<tr>
		    <td width='50' class='title'>�Ǽ�</td>
		    <td width='70' class='title'>�ܰ�</td>
		    <td width='100' class='title'>�հ�</td>
		    <td width='50' class='title'>�Ǽ�</td>
		    <td width='70' class='title'>�ܰ�</td>
		    <td width='100' class='title'>�հ�</td>
		    <td width='50' class='title'>�Ǽ�</td>
		    <td width='70' class='title'>�ܰ�</td>
		    <td width='100' class='title'>�հ�</td>
		    <td width='50' class='title'>�Ǽ�</td>
		    <td width='70' class='title'>�ܰ�</td>
		    <td width='100' class='title'>�հ�</td>
		    <td width='50' class='title'>�Ǽ�</td>
		    <td width='70' class='title'>�ܰ�</td>
		    <td width='100' class='title'>�հ�</td>
		    <td width='50' class='title'>�Ǽ�</td>
		    <td width='100' class='title'>�հ�</td>
		</tr>
	    </table>
	</td>
    </tr>	
<%	if(vt_size > 0)	{%>
    <tr>
	<td class='line' width='380' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>    	
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
		<tr>
		    <td width='100' align='center'><%=ht.get("NM")%></td>
		    <td width='60' align='center'><%=ht.get("DLV_EXT")%></td>
		    <td width='100' align='center'><%=ht.get("OFF_NM")%></td>
		    <td width='120' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=AddUtil.substringb(String.valueOf(ht.get("CAR_NM")), 16)%></td>
		</tr>		    
<%		}%>	
		<tr>		    
		    <td class='title' colspan='4'>�հ�</td>		   
		</tr>
	    </table>
	</td>
	<td class='line' width='1250'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>	    
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("H_CONS_AMT1")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("H_CONS_AMT2")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("H_CONS_AMT3")));
			total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("H_CONS_AMT4")));
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("H_CONS_AMT5")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("H_CONS_AMT6")));
			
			total_cnt1 	= total_cnt1 + AddUtil.parseInt(String.valueOf(ht.get("CNT1")));
			total_cnt2 	= total_cnt2 + AddUtil.parseInt(String.valueOf(ht.get("CNT2")));
			total_cnt3 	= total_cnt3 + AddUtil.parseInt(String.valueOf(ht.get("CNT3")));
			total_cnt4 	= total_cnt4 + AddUtil.parseInt(String.valueOf(ht.get("CNT4")));
			total_cnt5 	= total_cnt5 + AddUtil.parseInt(String.valueOf(ht.get("CNT5")));
			total_cnt6 	= total_cnt6 + AddUtil.parseInt(String.valueOf(ht.get("CNT6")));

%>		    
		<tr>				
		    <td width='50' align='center'><%=ht.get("CNT1")%></td>
		    <td width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("D_CONS_AMT1")))%></td>
		    <td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("H_CONS_AMT1")))%></td>
		    <td width='50' align='center'><%=ht.get("CNT2")%></td>
		    <td width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("D_CONS_AMT2")))%></td>
		    <td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("H_CONS_AMT2")))%></td>
		    <td width='50' align='center'><%=ht.get("CNT3")%></td>
		    <td width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("D_CONS_AMT3")))%></td>
		    <td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("H_CONS_AMT3")))%></td>
		    <td width='50' align='center'><%=ht.get("CNT4")%></td>
		    <td width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("D_CONS_AMT4")))%></td>
		    <td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("H_CONS_AMT4")))%></td>
		    <td width='50' align='center'><%=ht.get("CNT5")%></td>
		    <td width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("D_CONS_AMT5")))%></td>
		    <td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("H_CONS_AMT5")))%></td>
		    <td width='50' align='center'><%=ht.get("CNT6")%></td>
		    <td width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("H_CONS_AMT6")))%></td>
		</tr>
<%		}%>	
		<tr>											
		    <td class='title'><%=total_cnt1%></td>
		    <td class='title'>&nbsp;</td>
		    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>					
		    <td class='title'><%=total_cnt2%></td>					
		    <td class='title'>&nbsp;</td>					
		    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>					
		    <td class='title'><%=total_cnt3%></td>
		    <td class='title'>&nbsp;</td>
		    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>					
		    <td class='title'><%=total_cnt4%></td>					
		    <td class='title'>&nbsp;</td>					
		    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>					
		    <td class='title'><%=total_cnt5%></td>
		    <td class='title'>&nbsp;</td>
		    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt5)%></td>					
		    <td class='title'><%=total_cnt6%></td>					
		    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt6)%></td>					
		</tr>	
	    </table>
	</td>
    </tr>
<%	}else{%>
    <tr>
	<td class='line' width='360' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
			<%if(t_wd.equals("")){%>�˻�� �Է��Ͻʽÿ�.
			<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1250'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td>&nbsp;</td>
		</tr>
	    </table>
	</td>
    </tr>
<%	}%>    
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
