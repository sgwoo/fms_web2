<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*"%>
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
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 1; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	if(nm_db.getWorkAuthUser("�Ƹ���ī�̿�",user_id)){
		s_kd = "8";
	}
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//��ǰ���� ����
	function view_est(m_id, l_cd){
		window.open("/fms2/lc_rent/view_est.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&mode=board", "VIEW_STAT", "left=100, top=100, width=620, height=400, scrollbars=yes");		
	}
	//��ǰ���� ����
	function view_tint(m_id, l_cd){
		window.open("/fms2/car_pur/view_tint.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_TINT", "left=0, top=0, width=1020, height=500, scrollbars=yes");		
	}
	
	//�����ȣ ���
	function reg_estcarno(m_id, l_cd){
		window.open("reg_estcarno.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>&mode=board", "REG_ESTCARNO", "left=100, top=100, width=620, height=400, scrollbars=yes");					
	}
	
	//�ŷ�ó ���� 
	function view_client(rent_mng_id, rent_l_cd, r_st, car_mng_id)
	{
		var SUBWIN= "/fms2/con_fee/con_fee_client_s.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&r_st="+r_st;
		window.open(SUBWIN, "View_Client", "left=50, top=50, width=720, height=600, resizable=yes, scrollbars=yes");
	}

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) {
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}	
		
	//��ǰ����
	function tint_action(tint_no){
		var fm = document.form1;
		fm.tint_no.value 		= tint_no;			
		fm.action = 'tint_reg_step2.jsp';
		fm.target = 'd_content';
		fm.submit();
	}
		
	//�Ƿ�����
	function select_tint(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					cnt++;					
				}
			}
		}	
		if(cnt == 0){
		 	alert("������ ��ǰ�� �����ϼ���.");
			return;
		}	
		fm.target = "i_no";
		fm.action = "tint_w_rec_a.jsp";
		fm.submit();	
	}					
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/tint/tint_w_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='tint_no' value=''>  
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�� <input type='text' name='size' value='' size='4' class=whitenum> ��</span>
	  <%if((auth_rw.equals("4")||auth_rw.equals("6")) || (nm_db.getWorkAuthUser("������",user_id)) || user_id.equals("000144") || user_id.equals("000054")){%>   
	  &nbsp;&nbsp;&nbsp;&nbsp;
	  <a href="javascript:select_tint();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_np_js.gif" align="absmiddle" border="0"></a>
	  &nbsp;
	  <%}%>	  
	  </td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="tint_w_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
  <tr>
	  <td>�� ������û �Ⱓ�� ����Ʈ�� <font color=red>����</font>�Դϴ�. �ٸ� �Ⱓ���� �˻��Ҽ� �ֽ��ϴ�.  �Ƿ��ڰ� ���������� ���� ������Ʈ ����Դϴ�. ��� ó�� ���ּ���.</td>
	</tr>	
</table>
</form>
</body>
</html>
